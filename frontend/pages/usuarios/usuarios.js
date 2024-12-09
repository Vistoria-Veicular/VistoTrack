document.addEventListener("DOMContentLoaded", function() {
    // Selecionando o botão de busca
    const btnBuscar = document.getElementById("btn_buscar");

    // Função de busca quando o botão é clicado
    btnBuscar.addEventListener("click", function() {
        const busca = document.getElementById("id_pessoa").value; // Valor do campo de busca

        // Monta a URL com os parâmetros
        let url = "http://127.0.0.1:5000/pessoas";  // Adicionando o protocolo http://
        const params = [];

        // Verifica se o valor é um CPF ou nome e monta os parâmetros adequadamente
        if (busca) {
            if (busca.includes(' ')) {
                // Se busca contém espaço, provavelmente é um nome completo
                params.push("nome=" + encodeURIComponent(busca));
            } else {
                // Se não contém espaço, tenta tratar como CPF
                params.push("cpf=" + encodeURIComponent(busca));
            }
        }

        // Se houver parâmetros, os adiciona à URL
        if (params.length > 0) {
            url += "?" + params.join("&");
        }

        // Fazendo a requisição GET
        fetch(url)
            .then(response => {
                if (!response.ok) {
                    throw new Error("Erro na requisição: " + response.statusText);
                }
                return response.json();
            })
            .then(data => {
                // Se pessoas foram encontradas, exibe os resultados
                if (data.pessoas && data.pessoas.length > 0) {
                    console.log(data.pessoas); // Aqui você pode fazer algo com os dados, como preencher os campos do formulário ou exibir em uma lista

                    // Criação do combobox (select) e preenchimento com os nomes das pessoas
                    const idPessoaInput = document.getElementById("id_pessoa");
                    idPessoaInput.innerHTML = ''; // Limpar conteúdo anterior

                    // Criando o elemento <select>
                    const selectElement = document.createElement("select");
                    selectElement.setAttribute("name", "id_pessoa");
                    selectElement.setAttribute("id", "id_pessoa");

                    // Criando a primeira opção do combobox
                    const defaultOption = document.createElement("option");
                    defaultOption.textContent = "Selecione uma pessoa";
                    defaultOption.disabled = true;
                    defaultOption.selected = true;
                    selectElement.appendChild(defaultOption);

                    // Adicionando opções de nomes
                    data.pessoas.forEach(pessoa => {
                        const option = document.createElement("option");
                        option.value = pessoa.cpf; // Pode-se usar o CPF como o valor da opção, por exemplo
                        option.textContent = pessoa.nome; // O nome será exibido
                        selectElement.appendChild(option);
                    });

                    // Substituindo o campo de input pelo select
                    idPessoaInput.parentNode.replaceChild(selectElement, idPessoaInput);

                    // Adiciona evento de mudança para preencher o e-mail com base na seleção
                    selectElement.addEventListener("change", function() {
                        // Recupera o CPF selecionado
                        const selectedCpf = selectElement.value;

                        // Encontra a pessoa correspondente ao CPF selecionado
                        const selectedPerson = data.pessoas.find(pessoa => pessoa.cpf === selectedCpf);

                        if (selectedPerson) {
                            // Preenche o campo de e-mail com o e-mail da pessoa selecionada
                            document.getElementById("email").value = selectedPerson.email;
                            // Preenche o campo id_pessoa com o CPF
                            document.getElementById("id_pessoa").value = selectedCpf;
                        } else {
                            // Caso não encontre a pessoa (o que não deveria acontecer)
                            document.getElementById("email").value = '';
                            document.getElementById("id_pessoa").value = '';
                        }
                    });
                } else {
                    alert("Nenhum registro encontrado!");
                }
            })
            .catch(error => {
                console.error("Erro ao buscar pessoas: ", error);
                alert("Erro ao fazer a requisição. Tente novamente.");
            });
    });

    // Quando o formulário for submetido
    const form = document.getElementById('cadastroForm');
    form.addEventListener('submit', function(event) {
        event.preventDefault(); // Previne o comportamento padrão do formulário (não recarregar a página)

        // Coleta os dados do formulário
        const formData = {
            'id_pessoa': document.getElementById('id_pessoa').value,
            'email': document.getElementById('email').value,
            'senha': gerarSenhaCriptografada(document.getElementById('senha').value), // Criptografa a senha
            'tipo_usuario': document.getElementById('tipo_usuario').value,
            'permissao': document.getElementById('permissao').value,
            'ultimo_login': new Date().toISOString(), // Data e hora atuais para o último login
        };

        // Envia os dados via AJAX para o backend Flask
        fetch('http://127.0.0.1:5000/usuarios', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(formData) // Converte os dados para JSON
        })
        .then(response => response.json())
        .then(data => {
            // Se a requisição for bem-sucedida
            if (data.message) {
                document.getElementById('message').innerHTML = `<p style="color: green;">${data.message}</p>`;
            }
        })
        .catch(error => {
            // Se ocorrer um erro
            document.getElementById('message').innerHTML = `<p style="color: red;">Erro ao cadastrar o usuário: ${error.message}</p>`;
        });
    });
});

// Função para gerar uma senha criptografada (simulação simples)
function gerarSenhaCriptografada(senha) {
    // Gera um hash aleatório simples (exemplo)
    const hashAleatorio = Math.random().toString(36).substring(2, 15);
    // Concatenando o hash com a senha para garantir que o comprimento seja 255 caracteres
    const senhaComHash = senha + hashAleatorio;

    // Se a senha concatenada for menor que 255 caracteres, preenche com espaços
    return senhaComHash.padEnd(255, ' ');
}
