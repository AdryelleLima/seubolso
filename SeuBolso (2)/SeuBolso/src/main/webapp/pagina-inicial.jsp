<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.Usuario" %>
<%
    // Verifica se o usuário está logado
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
    if (usuarioLogado == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Início - SeuBolso</title>

    <!-- CSS -->
    <link href="css/main.css" rel="stylesheet" />
    <link href="css/pagina-inicial.css" rel="stylesheet" />

    <!-- JS -->
    <script defer src="js/navbar.js"></script>
    <script defer src="js/main.js"></script>
    <script defer src="js/pagina-inicial.js"></script>
</head>

<body>
    <!-- Navbar dinâmico -->
    <div id="navbar-container"></div>

    <div class="conteudo">
        <h1>Bem-vindo, <%= usuarioLogado.getNome() %>!</h1>
        <p>Gerencie suas finanças de forma simples e eficiente.</p>
    </div>

    <div class="carrosel">
        <div class="carrosel-slide">
            <div class="carrosel-item">
                <img alt="painel" src="img/painel.png" />
            </div>
            <div class="carrosel-item">
                <img alt="planejamento financeiro" src="img/PROCESSO-DE-PLANEJAMENTO-FINANCEIRO.png" />
            </div>
        </div>
        <div class="carrosel-indicadores"></div>
    </div>

    <jsp:include page="footer.jsp" />
</body>

</html>
