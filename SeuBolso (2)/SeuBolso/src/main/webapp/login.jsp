<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Login</title>

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet" />
    <link href="css/main.css" rel="stylesheet" />
    <link href="css/login.css" rel="stylesheet" />
</head>
<body>
    <div class="cadastro-container">
        <!-- Botão de Voltar -->
        <div class="back-btn">
            <button class="btn voltar" type="button" onclick="window.location.href='index.jsp'">
                <i class="bi bi-arrow-left"></i> Voltar
            </button>
        </div>

        <div class="cadastro-header">
            <div class="logo-container">
                <img alt="logo" src="./img/logo.png" />
            </div>
            <h1>Login</h1>
        </div>

        <!-- Formulário de Login -->
        <form id="login-form" action="<%= request.getContextPath() %>/LoginServlet" method="post">
            <label for="email">Email</label>
            <input id="email" name="email" placeholder="Digite o Email" type="text" required />

            <label for="senha">Senha</label>
            <input id="senha" name="senha" placeholder="Digite a Senha" type="password" required />

            <div class="termos">
                <label>
                    <input checked="checked" name="lembrar" type="checkbox" />
                    Lembre-se de mim
                </label>
            </div>

            <div class="buttons">
                <button class="btn cancelar" type="button" onclick="window.location.href='cadastro.jsp'">
                    Cadastrar-se
                </button>
                <button class="btn finalizar" type="submit">Entrar</button>
            </div>

            <%-- Mensagem de erro do login --%>
            <c:if test="${not empty mensagem}">
                <div class="erro-login" style="color:red; margin-top:10px;">
                    ${mensagem}
                </div>
            </c:if>
        </form>
    </div>
</body>
</html>
