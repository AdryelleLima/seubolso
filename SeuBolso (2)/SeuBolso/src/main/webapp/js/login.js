document.addEventListener("DOMContentLoaded", function() {
    var form = document.querySelector("form");
    if (!form) return;

    // Função para mostrar toast ou fallback
    function toastFallback(msg, type) {
        type = type || "info";
        if (typeof window.showToast === "function") {
            window.showToast(msg, type);
        } else {
            alert(msg);
        }
    }

    form.addEventListener("submit", function(e) {
        e.preventDefault();

        var emailEl = document.getElementById("email");
        var senhaEl = document.getElementById("senha");
        if (!emailEl || !senhaEl) return;

        var email = emailEl.value.trim();
        var senha = senhaEl.value.trim();

        if (!email || !senha) {
            toastFallback("Preencha todos os campos!", "error");
            return;
        }

        // Usando FormData para compatibilidade com Servlet clássico
        var formData = new FormData();
        formData.append("email", email);
        formData.append("senha", senha);

        var xhr = new XMLHttpRequest();
        xhr.open("POST", "login", true); // caminho do seu LoginServlet
        xhr.onload = function() {
            if (xhr.status === 200) {
                var usuario = JSON.parse(xhr.responseText);
                localStorage.setItem("usuarioLogado", JSON.stringify(usuario));
                toastFallback("Login realizado com sucesso!", "success");
                setTimeout(function() {
                    window.location.href = "index.jsp";
                }, 1000);
            } else if (xhr.status === 401) {
                toastFallback("Email ou senha incorretos!", "error");
            } else {
                toastFallback("Erro ao fazer login. Tente novamente!", "error");
            }
        };
        xhr.onerror = function() {
            toastFallback("Erro de conexão com o servidor!", "error");
        };
        xhr.send(formData);
    });
});
