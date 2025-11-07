<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.Usuario" %>
<!DOCTYPE html>
<html lang="pt-br">

<head>
  <meta charset="utf-8" />
  <meta content="width=device-width, initial-scale=1.0" name="viewport" />
  <title>Cadastro</title>
  <link href="css/main.css" rel="stylesheet" />
  <link href="css/cadastro.css" rel="stylesheet" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet" />
</head>

<body>
  <div id="navbar-container"></div>

  <div class="cadastro-container">
    <div class="back-btn">
      <button class="btn voltar" type="button" onclick="window.location.href='login.jsp'">
        <i class="bi bi-arrow-left"></i> Voltar
      </button>
    </div>

    <div class="cadastro-header">
      <div class="logo-container">
        <img alt="logo" src="./img/logo.png" />
      </div>
      <h1>Cadastro</h1>
    </div>

    <p>Por favor, preencha os dados abaixo para criar sua conta.</p>

    <!-- Formulário envia para o servlet corretamente -->
    <form action="<%= request.getContextPath() %>/CadastroServlet" method="POST" id="cadastro-form">

      <label for="nome">Nome</label>
      <input id="nome" name="nome" placeholder="Digite seu nome" type="text" required />

      <label for="email">Email</label>
      <input id="email" name="email" placeholder="Digite seu email" type="email" required />

      <label for="senha">Senha</label>
      <input id="senha" name="senha" placeholder="Digite sua senha" type="password" required />

      <div class="termos">
        <label>
          <input type="checkbox" name="lembrar" checked /> Lembre-se de mim
        </label>
      </div>

      <div class="termos">
        <input type="checkbox" name="termos" required />
        <span>Ao criar uma conta, você concorda com nossos
          <a href="#">Termos e Privacidade</a>.
        </span>
      </div>

      <div class="buttons">
        <button class="btn cancelar" type="button" onclick="window.location.href='login.jsp'">
          Entrar
        </button>
        <button class="btn finalizar" type="submit">
          Finalizar Cadastro
        </button>
      </div>
    </form>

    <!-- Mensagem do servlet -->
    <%
        String msg = (String) request.getAttribute("mensagem");
        if (msg != null) {
    %>
        <div class="mensagem">
            <%= msg %>
        </div>
    <%
        }
    %>
  </div>

  <!-- Validação do formulário -->
  <script>
    document.addEventListener("DOMContentLoaded", function () {
      const form = document.getElementById("cadastro-form");
      if (!form) return;

      function toastFallback(msg, type) {
        if (typeof window.showToast === "function") {
          window.showToast(msg, type || "info");
        } else {
          alert(msg);
        }
      }

      form.addEventListener("submit", function (e) {
        const nome = document.getElementById("nome").value.trim();
        const email = document.getElementById("email").value.trim();
        const senha = document.getElementById("senha").value.trim();
        const termos = form.querySelector('input[name="termos"]').checked;

        if (!nome || !email || !senha) {
          e.preventDefault();
          toastFallback("Preencha todos os campos!", "error");
          return;
        }

        if (!termos) {
          e.preventDefault();
          toastFallback("Você deve aceitar os termos de uso!", "error");
          return;
        }

        // Formulário será enviado normalmente para o CadastroServlet
      });
    });
  </script>

  <script src="js/main.js"></script>
  <script src="js/cadastro.js"></script>
</body>

</html>
