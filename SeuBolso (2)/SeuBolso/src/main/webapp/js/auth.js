document.addEventListener("DOMContentLoaded", function () {
    // Função para verificar se o usuário está logado
    function verificarLogin() {
        var usuario = localStorage.getItem("usuarioLogado");
        if (!usuario) {
            // Se não estiver logado, redireciona para login
            window.location.href = "login.jsp";
        } else {
            return JSON.parse(usuario);
        }
    }

    // Fallback para toast
    function toastFallback(msg, type) {
        if (typeof window.showToast === "function") {
            window.showToast(msg, type || "info");
        } else {
            alert(msg);
        }
    }

    // Expor funções globalmente
    window.auth = {
        usuarioLogado: verificarLogin(),
        logout: function () {
            localStorage.removeItem("usuarioLogado");
            toastFallback("Você foi deslogado.", "info");
            setTimeout(function () {
                window.location.href = "login.jsp";
            }, 500);
        },
        verificarLogin: verificarLogin
    };
});
