const estadosECidades = {
    AC: ["Rio Branco", "Cruzeiro do Sul", "Sena Madureira"],
    AL: ["Maceió", "Arapiraca", "Palmeira dos Índios"],
    AP: ["Macapá", "Santana", "Oiapoque"],
    AM: ["Manaus", "Parintins", "Itacoatiara"],
    BA: ["Salvador", "Feira de Santana", "Vitória da Conquista"],
    CE: ["Fortaleza", "Juazeiro do Norte", "Sobral"],
    ES: ["Vitória", "Vila Velha", "Serra"],
    GO: ["Goiânia", "Anápolis", "Aparecida de Goiânia", 'Brasilia'],
    MA: ["São Luís", "Imperatriz", "Caxias"],
    MT: ["Cuiabá", "Várzea Grande", "Rondonópolis"],
    MS: ["Campo Grande", "Dourados", "Três Lagoas"],
    MG: ["Belo Horizonte", "Uberlândia", "Contagem"],
    PA: ["Belém", "Ananindeua", "Marabá"],
    PB: ["João Pessoa", "Campina Grande", "Patos"],
    PR: ["Curitiba", "Londrina", "Maringá"],
    PE: ["Recife", "Olinda", "Caruaru"],
    PI: ["Teresina", "Parnaíba", "Picos"],
    RJ: ["Rio de Janeiro", "Niterói", "Nova Iguaçu"],
    RN: ["Natal", "Mossoró", "Parnamirim"],
    RS: ["Porto Alegre", "Caxias do Sul", "Pelotas"],
    RO: ["Porto Velho", "Ji-Paraná", "Ariquemes"],
    RR: ["Boa Vista"],
    SC: ["Florianópolis", "Joinville", "Blumenau"],
    SP: ["São Paulo", "Campinas", "Santos", 'Atibaia'],
    SE: ["Aracaju", "Nossa Senhora do Socorro", "Lagarto"],
    TO: ["Palmas", "Araguaína", "Gurupi"],
};

document.addEventListener("DOMContentLoaded", () => {
    const estadoSelect = document.getElementById("estadoNascimento");
    for (const estado in estadosECidades) {
        const option = document.createElement("option");
        option.value = estado;
        option.textContent = estado;
        estadoSelect.appendChild(option);
    }
});

function atualizarCidades() {
    const estadoSelect = document.getElementById("estadoNascimento");
    const cidadeSelect = document.getElementById("cidadeNascimento");
    const cidades = estadosECidades[estadoSelect.value] || [];

    cidadeSelect.innerHTML = '<option value="">Selecione a Cidade</option>';

    cidades.forEach((cidade) => {
        const option = document.createElement("option");
        option.value = cidade;
        option.textContent = cidade;
        cidadeSelect.appendChild(option);
    });
}

function toggleLocalNascimento() {
    const localNascimento = document.getElementById("localNascimento").value;
    document.getElementById("nacional").style.display = localNascimento === "nacional" ? "flex" : "none";
    document.getElementById("estrangeiro").style.display = localNascimento === "estrangeiro" ? "block" : "none";
}

// Função para enviar os dados do formulário para o backend
document.getElementById("formPessoa").addEventListener("submit", function (event) {
    event.preventDefault(); // Impede o envio do formulário tradicional

    // Coletando os valores dos campos do formulário
    const nomeCompleto = document.getElementById("nomeCompleto").value;
    const dataNascimento = document.getElementById("dataNascimento").value;
    const cpf = document.getElementById("cpf").value;
    const rg = document.getElementById("rg").value;
    const cep = document.getElementById("cep").value;
    const logradouro = document.getElementById("logradouro").value;
    const numero = document.getElementById("numero").value;
    const complemento = document.getElementById("complemento").value;
    const telefone = document.getElementById("telefone").value;
    const email = document.getElementById("email").value;
    const mae = document.getElementById("mae").value;
    const estado = document.getElementById("estadoNascimento").value;
    const cidade = document.getElementById("cidadeNascimento").value;
    const localNascimento = document.getElementById("pais").value;

    // Definir a nacionalidade como 'Brasil' se o campo de localNascimento for 'nacional'
    const naturalidade = localNascimento === "nacional" ? "Brasil" : "";

    // Criando o objeto de dados para enviar via POST
    const dados = {
        nomeCompleto,
        dataNascimento,
        cpf,
        rg,
        cep,
        logradouro,
        numero,
        complemento,
        telefone,
        email,
        mae,
        estado,
        cidade,
        localNascimento,
        naturalidade, // Adicionando nacionalidade ao objeto de dados
    };

    // Enviar os dados para o backend (endpoint /cadastro)
    fetch("http://localhost:5000/cadastro", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify(dados),
    })
    .then(response => response.json())
    .then(data => {
        alert("Dados enviados com sucesso!");
    })
    .catch(error => {
        console.error("Erro ao enviar dados:", error);
    });
});
