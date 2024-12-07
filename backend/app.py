from flask import Flask, request, jsonify
from flask_mysqldb import MySQL
from flask_cors import CORS  # Importando a extensão CORS

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
def submit():
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

if __name__ == '__main__':
    app.run(debug=True)

