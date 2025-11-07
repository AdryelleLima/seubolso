document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("cadastro-form");
    if (!form) return;

    // Função fallback para toast
    function toastFallback(msg, type = "info") {
        if (typeof window.showToast === "function") {
            window.showToast(msg, type);
        } else {
            alert(msg);
        }
    }

    form.addEventListener("submit", function (e) {
        const nome = document.getElementById("nome").value.trim();
        const email = document.getElementById("email").value.trim();
        const senha = document.getElementById("senha").value.trim();
        const termos = form.querySelector('input[name="termos"]').checked;

        // Validação dos campos obrigatórios
        if (!nome || !email || !senha) {
            e.preventDefault();
            toastFallback("Preencha todos os campos!", "error");
            return;
        }

        // Validação do checkbox de termos
        if (!termos) {
            e.preventDefault();
            toastFallback("Você deve aceitar os termos de uso!", "error");
            return;
        }

        // Se passou nas validações, o formulário será enviado normalmente
        // Sem AJAX, para que o CadastroServlet processe
    });
});
