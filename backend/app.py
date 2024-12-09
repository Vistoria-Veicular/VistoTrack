from flask import Flask, request, jsonify
from flask_mysqldb import MySQL
from flask_cors import CORS  # Importando a extensão CORS
from MySQLdb import IntegrityError
import datetime
import hashlib

# Inicializa o app Flask
app = Flask(__name__)

# Configuração do CORS
CORS(app)  # Isso habilita CORS para todos os domínios. Se quiser restringir, veja o próximo exemplo.

# Configuração do banco de dados MySQL
app.config['MYSQL_HOST'] = 'localhost'  # Endereço do servidor MySQL
app.config['MYSQL_USER'] = 'Ali'  # Usuário do banco de dados
app.config['MYSQL_PASSWORD'] = '@Alison2004'  # Senha do banco de dados (deixe vazia se não houver)
app.config['MYSQL_DB'] = 'vistoriaveicular'  # Nome do banco de dados

# Inicializa o objeto MySQL
mysql = MySQL(app)

# Endpoint para receber as informações do formulário via JSON
@app.route('/cadastro', methods=['POST'])
def cadastro():
    # Recebe os dados do formulário como JSON
    data = request.get_json()

    # Extrair as variáveis do JSON recebido
    nome_completo = data.get('nomeCompleto')
    data_nascimento = data.get('dataNascimento')
    cpf = data.get('cpf')
    rg = data.get('rg')
    cep = data.get('cep')
    logradouro = data.get('logradouro')
    numero = data.get('numero')
    complemento = data.get('complemento', '')
    naturalidade = data.get('naturalidade')
    estado = data.get('estado')
    cidade = data.get('cidade')
    telefone = data.get('telefone')
    email = data.get('email')
    mae = data.get('mae', '')

    # Conectar ao banco de dados
    cur = mysql.connection.cursor()

    # Query para inserir os dados na tabela Pessoas
    query = """
        INSERT INTO Pessoas (Nome, CPF, CEP, Logradouro, numero, complemento, Naturalidade, Estado, Cidade, EMail, RG, mae, Telefone, Nascimento)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    """
    values = (nome_completo, cpf, cep, logradouro, numero, complemento, naturalidade, estado, cidade, email, rg, mae, telefone, data_nascimento)

    # Executar a query e confirmar a transação
    cur.execute(query, values)
    mysql.connection.commit()

    # Fechar a conexão com o banco de dados
    cur.close()

    # Retornar uma resposta de sucesso no formato JSON
    return jsonify({"message": "Dados enviados com sucesso!"}), 200

# Endpoint para buscar pessoas (GET) com parâmetros opcionais
@app.route('/pessoas', methods=['GET'])
def buscar_pessoas():
    # Obter os parâmetros de busca: nome e cpf (se existirem)
    nome = request.args.get('nome', default='', type=str)
    cpf = request.args.get('cpf', default='', type=str)

    # Conectar ao banco de dados
    cur = mysql.connection.cursor()

    # Montar a query de busca com base nos parâmetros
    query = "SELECT * FROM Pessoas"  # 1=1 garante que sempre haverá uma condição
    params = []

    if nome:
        query += " WHERE Nome LIKE %s;"
        params.append(f"%{nome}%")
    elif cpf:
        query += " WHERE CPF = %s;"
        params.append(cpf)
    else:
        query += ";"

    # Executa a query com os parâmetros fornecidos
    cur.execute(query, tuple(params))
    
    # Recuperar os resultados
    resultados = cur.fetchall()

    # Fechar a conexão com o banco de dados
    cur.close()

    # Se não encontrar resultados após o filtro
    if not resultados:
        return jsonify({"message": "Nenhum registro encontrado com os critérios informados."}), 404

    # Formatar os resultados em formato JSON
    pessoas = []
    for pessoa in resultados:
        pessoa_dict = {
            "id": pessoa[0],
            "nome": pessoa[1],
            "cpf": pessoa[2],
            "cep": pessoa[3],
            "logradouro": pessoa[4],
            "numero": pessoa[5],
            "complemento": pessoa[6],
            "naturalidade": pessoa[7],
            "estado": pessoa[8],
            "cidade": pessoa[9],
            "email": pessoa[10],
            "rg": pessoa[11],
            "mae": pessoa[12],
            "telefone": pessoa[13],
            "nascimento": pessoa[14].strftime('%Y-%m-%d'),  # Formatar data
        }
        pessoas.append(pessoa_dict)

    # Retorna os dados encontrados
    return jsonify({"pessoas": pessoas}), 200


# Função para inserir um novo usuário
@app.route('/usuarios', methods=['POST'])
def criar_usuario():
    try:
        # Receber os dados da requisição
        data = request.get_json()

        # Verificar se todos os dados necessários foram fornecidos
        if not all(key in data for key in ['EMail', 'Senha', 'Tipo_Usuario', 'Permissao', 'Id_Pessoa']):
            return jsonify({'error': 'Dados incompletos'}), 400

        # Conectar ao banco de dados
        cur = mysql.connection.cursor()
        cursor = cur.cursor()

        # Hash da senha usando SHA256 (recomendação: use bcrypt para produção)
        hash_senha = hashlib.sha256(data['Senha'].encode()).hexdigest()

        # Definindo o momento atual como o último login
        ultimo_login = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')

        # Inserir o usuário no banco de dados
        query = """
            INSERT INTO Usuarios (EMail, Senha, Hash, Tipo_Usuario, Permissao, Ultimo_Login, Final_Usuario, Id_Pessoa)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """
        values = (data['EMail'], data['Senha'], hash_senha, data['Tipo_Usuario'], data['Permissao'], ultimo_login, 0, data['Id_Pessoa'])

        cursor.execute(query, values)

        # Commitando a transação
        cur.commit()

        # Fechar conexão
        cursor.close()
        cur.close()

        # Retornar resposta de sucesso
        return jsonify({'message': 'Usuário criado com sucesso!'}), 201

    except mysql.connector.Error as err:
        return jsonify({'error': f'Erro ao acessar o banco de dados: {err}'}), 500
    except Exception as e:
        return jsonify({'error': f'Erro interno: {str(e)}'}), 500


# Endpoint para criar um novo veículo
@app.route('/veiculos', methods=['POST'])
def create_vehicle():
    try:
        # Obtendo os dados do corpo da requisição
        data = request.get_json()

        # Validando os campos obrigatórios
        required_fields = ['Marca', 'Modelo', 'Ano_Fabricacao', 'placa', 'ultima_verificacao', 'Status', 'Id_condutor']
        for field in required_fields:
            if field not in data:
                return jsonify({'error': f'O campo {field} é obrigatório'}), 400

        # Acessando os valores do JSON
        marca = data['Marca']
        modelo = data['Modelo']
        ano_fabricacao = data['Ano_Fabricacao']
        placa = data['placa']
        ultima_verificacao = data['ultima_verificacao']
        status = data['Status']
        id_condutor = data['Id_condutor']

        # Verificando se a data de última verificação é válida
        try:
            ultima_verificacao = datetime.strptime(ultima_verificacao, '%Y-%m-%dT%H:%M:%S')
        except ValueError:
            return jsonify({'error': 'Formato da data de ultima_verificacao inválido. Use "YYYY-MM-DDTHH:MM:SS".'}), 400

        # Criando o cursor para execução das queries
        cursor = mysql.cursor()

        # Query para inserir o veículo
        query = """
        INSERT INTO Veiculos (Marca, Modelo, Ano_Fabricacao, placa, ultima_verificacao, Status, Id_condutor)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
        """
        cursor.execute(query, (marca, modelo, ano_fabricacao, placa, ultima_verificacao, status, id_condutor))
        
        # Confirmando a transação
        mysql.commit()

        # Retorna a resposta com o ID do novo veículo inserido
        return jsonify({'message': 'Veículo inserido com sucesso!'}), 201

    except IntegrityError as e:
        # Caso ocorra erro de integridade (exemplo: chave estrangeira quebrada)
        return jsonify({'error': 'Erro ao inserir veículo. Verifique os dados informados.'}), 400
    except Exception as e:
        # Erros inesperados
        return jsonify({'error': str(e)}), 500
    finally:
        # Fechar o cursor e a conexão
        cursor.close()

if __name__ == '__main__':
    app.run(debug=True)

