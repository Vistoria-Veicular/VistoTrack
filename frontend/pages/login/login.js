document.getElementById('loginForm').addEventListener('submit', function(event) {
    event.preventDefault();  

    const email = document.getElementById('email').value;
    const senha = document.getElementById('senha').value;

    if (email === '') {
        alert('Por favor, preencha o campo E-mail!');
        return; 
    }

    if (senha === '') {
        alert('Por favor, preencha o campo Senha!');
        return; 
    }

    alert('Login bem-sucedido!');
});
