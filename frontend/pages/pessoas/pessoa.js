const estadosECidades = {
    AC: ["Rio Branco", "Cruzeiro do Sul", "Sena Madureira"],
    AL: ["Maceió", "Arapiraca", "Palmeira dos Índios"],
    AP: ["Macapá", "Santana", "Oiapoque"],
    AM: ["Manaus", "Parintins", "Itacoatiara"],
    BA: ["Salvador", "Feira de Santana", "Vitória da Conquista"],
    CE: ["Fortaleza", "Juazeiro do Norte", "Sobral"],
    DF: ["Brasília"],
    ES: ["Vitória", "Vila Velha", "Serra"],
    GO: ["Goiânia", "Anápolis", "Aparecida de Goiânia"],
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
    SP: ["São Paulo", "Campinas", "Santos"],
    SE: ["Aracaju", "Nossa Senhora do Socorro", "Lagarto"],
    TO: ["Palmas", "Araguaína", "Gurupi"],
};

document.addEventListener("DOMContentLoaded", () => {
    const estadoSelect = document.getElementById("estado");
    for (const estado in estadosECidades) {
        const option = document.createElement("option");
        option.value = estado;
        option.textContent = estado;
        estadoSelect.appendChild(option);
    }
});

function atualizarCidades() {
    const estadoSelect = document.getElementById("estado");
    const cidadeSelect = document.getElementById("cidade");
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
