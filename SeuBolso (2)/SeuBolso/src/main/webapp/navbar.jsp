<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="models.Usuario"%>

<%
Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
%>


<header class="navbar-container">
	<link href="css/navbar.css" rel="stylesheet" />
	<!-- Botão menu lateral -->
	<button class="hamburguer" id="hamburguer-btn">☰</button>

	<!-- Marca -->
	<div class="barra-esquerda">
		<a href="index.jsp" class="logo-link"> <img alt="logo-marca"
			class="marca" src="img/logo.png" /> <span class="logo">SeuBolso</span>
		</a>
	</div>


	<!-- Navegação principal -->
	<nav class="barra-meio">
		<a href="Home.jsp">Visão Geral</a> <a href="calendario.jsp">Calendário</a>
		<a href="lancamento.jsp">Lançamento</a> <a href="ListaDesejosServlet">Lista
			de Desejos</a> <a href="relatorio.jsp">Relatório</a>
	</nav>

	<!-- Navegação direita -->
	<nav class="barra-direita">
		<!-- Botão de Notificação -->
		<a href="#" id="notificacao-btn"
			style="display: inline-block; padding: 0 8px; position: relative;">
			<span style="font-size: 1.3em; color: #222; vertical-align: middle;">🔔</span>
			<span id="notificacao-badge"
			style="position: absolute; top: 0px; right: 0px; background: #e53935; color: #fff; font-size: 0.75em; font-weight: bold; border-radius: 50%; padding: 1px 5px; min-width: 16px; height: 16px; line-height: 14px; text-align: center; box-shadow: 0 1px 4px rgba(0, 0, 0, 0.12); display: none;">
				0 </span>
		</a>

		<!-- Botão de Configuração/Perfil -->
		<%
		if (usuario != null) {
		%>
		<!-- Usuário logado: mostra foto de perfil -->
		<a href="#" id="configuracao-btn"
			style="display: inline-block; padding: 0 8px;">
			<div
				style="width: 32px; height: 32px; border-radius: 50%; overflow: hidden; border: 2px solid #1a4d2e; display: flex; align-items: center; justify-content: center; background: #f0f0f0;">
				<%
				if (usuario.getFotoPerfil() != null && !usuario.getFotoPerfil().isEmpty()) {
				%>
				<img src="<%=usuario.getFotoPerfil()%>" alt="Perfil"
					style="width: 100%; height: 100%; object-fit: cover;">
				<%
				} else {
				%>
				<img src="img/logo.png" alt="Perfil"
					style="width: 100%; height: 100%; object-fit: cover;">
				<%
				}
				%>
			</div>
		</a>
		<%
		} else {
		%>
		<!-- Usuário não logado: mostra engrenagem -->
		<a href="#" id="configuracao-btn"
			style="display: inline-block; padding: 0 8px;"> <span
			style="font-size: 1.5em; color: #222; vertical-align: middle;">⚙️</span>
		</a>
		<%
		}
		%>
	</nav>
</header>

<!-- Fundo escurecido -->
<div id="overlay"></div>

<!-- Popover Configurações -->
<div id="popover-configuracao" class="popover-config-dark">
	<h2 class="popover-config-title">Configurações</h2>
	<ul class="popover-config-list">
		<%
		if (usuario != null) {
		%>
		<li><a href="perfil.jsp" class="popover-link">👤 Perfil</a></li>
		<li><a href="manual.jsp" class="popover-link">📖 Manual</a></li>
		<li><a href="#" id="logout-link" class="popover-link">🚪 Sair</a></li>
		<%
		} else {
		%>
		<li><a href="login.jsp" class="popover-link" id="popover-login">🔑
				Login</a></li>
		<li><a href="cadastro.jsp" class="popover-link">📝 Cadastrar</a></li>
		<li><a href="manual.jsp" class="popover-link">📖 Manual</a></li>
		<%
		}
		%>
	</ul>
	<button id="fechar-popover-config" class="btn-fechar-popover">Fechar</button>
</div>

<!-- Popover Notificações -->
<div id="popover-notificacao"
	style="display: none; position: absolute; z-index: 1000;">
	<div
		style="min-width: 320px; max-width: 400px; background: white; border-radius: 12px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15); border: 1px solid #e0e0e0; overflow: hidden;">

		<!-- Header -->
		<div
			style="background: linear-gradient(135deg, #1a4d2e 0%, #2d6a4f 100%); padding: 16px 18px; border-bottom: 1px solid rgba(255, 255, 255, 0.1);">
			<h2
				style="margin: 0; font-size: 1.1em; color: white; font-weight: 600; display: flex; align-items: center; gap: 8px;">
				<span style="font-size: 1.3em;">🔔</span> Notificações
			</h2>
		</div>

		<!-- Lista de Notificações -->
		<ul id="notificacao-lista"
			style="list-style: none; padding: 8px; margin: 0; max-height: 400px; overflow-y: auto; background: #f8f9fa;">
			<li style="padding: 12px; color: #999; text-align: center;">
				Carregando notificações...</li>
		</ul>

		<!-- Footer -->
		<div
			style="padding: 12px 18px; background: white; border-top: 1px solid #e0e0e0; display: flex; justify-content: space-between; align-items: center;">
			<small style="color: #7f8c8d; font-size: 0.85em;"> <i
				class="fas fa-info-circle"></i> Clique no × para remover
			</small>
			<button id="fechar-popover-notificacao"
				style="padding: 6px 16px; background: linear-gradient(135deg, #1a4d2e 0%, #2d6a4f 100%); color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; font-size: 0.9em; transition: all 0.2s ease;">
				Fechar</button>
		</div>
	</div>
</div>

<!-- Menu lateral -->
<aside class="menu-lateral" id="menu-lateral">
	<button class="fechar" id="fechar-menu">×</button>
	<a href="Home.jsp">Visão Geral</a> <a href="calendario.jsp">Calendário</a>
	<a href="lancamento.jsp">Lançamento</a> <a href="lista-desejos.jsp">Lista
		de Desejos</a> <a href="relatorio.jsp">Relatório</a>
	<%
	if (usuario != null) {
	%>
	<a href="perfil.jsp">Perfil</a> <a href="manual.jsp">Manual</a> <a
		href="#" id="menu-logout">Sair</a>
	<%
	} else {
	%>
	<a href="login.jsp" id="menu-login">Login</a> <a href="cadastro.jsp">Cadastrar</a>
	<a href="manual.jsp">Manual</a>
	<%
	}
	%>
</aside>

<!-- Toast Container -->
<div id="toast-container" class="position-fixed bottom-0 end-0 p-3"
	style="z-index: 1100"></div>

<!-- Estilos do Popover Escuro -->
<style>
/* Popover Configurações - Tema Escuro */
.popover-config-dark {
	display: none;
	position: absolute;
	z-index: 1000;
	min-width: 220px;
	max-width: 95vw;
	background: linear-gradient(135deg, #1a4d2e 0%, #2d6a4f 100%);
	border-radius: 10px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
	padding: 16px 14px;
	border: 1px solid rgba(255, 255, 255, 0.1);
	overflow: auto;
}

.popover-config-title {
	margin-top: 0;
	font-size: 1.1em;
	color: #ffffff;
	font-weight: 500;
	margin-bottom: 12px;
}

.popover-config-list {
	list-style: none;
	padding: 0;
	margin: 0 0 12px 0;
}

.popover-config-list li {
	margin-bottom: 4px;
}

.popover-link {
	display: block;
	padding: 10px 12px;
	color: #ecf0f1;
	text-decoration: none;
	border-radius: 6px;
	transition: all 0.2s ease;
	font-size: 0.95em;
}

.popover-link:hover {
	background: rgba(255, 255, 255, 0.1);
	color: #ffffff;
	transform: translateX(4px);
}

.btn-fechar-popover {
	width: 100%;
	padding: 8px 12px;
	background: rgba(255, 255, 255, 0.15);
	color: #ffffff;
	border: 1px solid rgba(255, 255, 255, 0.2);
	border-radius: 6px;
	cursor: pointer;
	font-size: 0.9em;
	font-weight: 500;
	transition: all 0.2s ease;
}

.btn-fechar-popover:hover {
	background: rgba(255, 255, 255, 0.25);
	border-color: rgba(255, 255, 255, 0.3);
}
</style>

<!-- Script principal do navbar -->
<script src="js/navbar.js"></script>

<!-- CSS adicional para foto de perfil no navbar -->
<style>
#configuracao-btn img {
	transition: transform 0.2s ease, box-shadow 0.2s ease;
}

#configuracao-btn:hover img {
	transform: scale(1.05);
	box-shadow: 0 2px 8px rgba(26, 77, 46, 0.3);
}

#configuracao-btn div {
	transition: border-color 0.2s ease;
}

#configuracao-btn:hover div {
	border-color: #2d6a4f;
}
</style>

<script>
document.addEventListener("DOMContentLoaded", () => {
    // Bloqueia acesso a páginas restritas se não estiver logado
    const usuarioLogado = <%=usuario != null ? "true" : "false"%>;
    const linksRestritos = ["calendario.jsp", "lancamento.jsp", "lista-desejos.jsp", "relatorio.jsp", "perfil.jsp"];

    linksRestritos.forEach((href) => {
        document.querySelectorAll(`a[href^="${href}"]`).forEach((a) => {
            a.addEventListener("click", function (e) {
                if (!usuarioLogado) {
                    e.preventDefault();
                    alert("Você precisa estar logado para acessar esta página!");
                }
            });
        });
    });
});
</script>