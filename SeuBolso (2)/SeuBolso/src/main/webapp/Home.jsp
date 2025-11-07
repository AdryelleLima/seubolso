<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.Usuario"%>
<%@ page import="models.Lancamento"%>
<%@ page import="java.util.List"%>
<%@ page import="dao.LancamentoDAO"%>
<%@ page import="util.JDBCUtil"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%
Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
if (usuario == null) {
	response.sendRedirect("login.jsp");
	return;
}

// Conecta ao banco e pega lançamentos do usuário
List<Lancamento> lancamentos;
double receitaMensal = 0;
double despesaMensal = 0;
double saldoGeral = 0;

try (java.sql.Connection con = JDBCUtil.getConnection()) {
	LancamentoDAO lancamentoDAO = new LancamentoDAO(con);
	lancamentos = lancamentoDAO.listarPorUsuario(usuario);

	for (Lancamento l : lancamentos) {
		if ("receita".equalsIgnoreCase(l.getTipo())) {
			receitaMensal += l.getValor();
			saldoGeral += l.getValor();
		} else {
			despesaMensal += l.getValor();
			saldoGeral -= l.getValor();
		}
	}
} catch (Exception e) {
	lancamentos = java.util.Collections.emptyList();
	e.printStackTrace();
}
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Dashboard - SeuBolso</title>
	
	<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet" />
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
	<link href="css/main.css" rel="stylesheet" />
	<link href="css/Home.css" rel="stylesheet" />
</head>
<body>
	<jsp:include page="navbar.jsp" />

	<main class="main-container">
		<!-- ========================= HEADER COM SAUDAÇÃO ========================= -->
		<div class="section-form welcome-card">
			<div class="welcome-content">
				<div class="welcome-text">
					<h2>
						<i class="fas fa-hand-wave me-2" style="color: #f39c12;"></i>
						Olá, <strong><%= usuario.getNome() %></strong>!
					</h2>
					<p class="text-white mb-0" ">Bem-vindo de volta! Aqui está um resumo das suas finanças.</p>
				</div>
			</div>
		</div>

		<!-- ========================= RESUMO FINANCEIRO ========================= -->
		<div class="section-latest">
			<h2>
				<i class="fas fa-wallet me-2"></i>Resumo Financeiro
			</h2>

			<div class="resumo-financeiro-container">
				<!-- Coluna dos Cards -->
				<div class="resumo-cards-column">
					<div class="resumo-card receitas">
						<div class="resumo-icon">
							<i class="fas fa-arrow-up"></i>
						</div>
						<div class="resumo-info">
							<h4>Total de Receitas</h4>
							<p class="resumo-valor">
								R$ <%= String.format("%.2f", receitaMensal) %>
							</p>
						</div>
					</div>

					<div class="resumo-card despesas">
						<div class="resumo-icon">
							<i class="fas fa-arrow-down"></i>
						</div>
						<div class="resumo-info">
							<h4>Total de Despesas</h4>
							<p class="resumo-valor">
								R$ <%= String.format("%.2f", despesaMensal) %>
							</p>
						</div>
					</div>

					<div class="resumo-card saldo">
						<div class="resumo-icon">
							<i class="fas fa-balance-scale"></i>
						</div>
						<div class="resumo-info">
							<h4>Saldo Geral</h4>
							<p class="resumo-valor">
								R$ <%= String.format("%.2f", saldoGeral) %>
							</p>
						</div>
					</div>
				</div>

				<!-- Coluna do Gráfico -->
				<div class="grafico-container">
					<h3>
						<i class="fas fa-chart-pie me-2"></i>Distribuição Financeira
					</h3>
					<canvas id="grafico-financeiro"></canvas>
				</div>
			</div>
		</div>

		<!-- ========================= HISTÓRICO DE LANÇAMENTOS ========================= -->
		<div class="section-latest">
			<div class="historico-header">
				<h2>
					<i class="fas fa-history me-2"></i>Histórico de Lançamentos
				</h2>
				<a href="lancamento.jsp" class="btn btn-add-small">
					<i class="fas fa-plus me-2"></i>Novo Lançamento
				</a>
			</div>

			<% if (lancamentos.isEmpty()) { %>
				<div class="empty-state">
					<i class="fas fa-inbox fa-3x mb-3"></i>
					<h4>Nenhum lançamento encontrado</h4>
					<p>Comece adicionando suas receitas e despesas para acompanhar suas finanças.</p>
					<a href="lancamentos.jsp" class="btn btn-add mt-3">
						<i class="fas fa-plus me-2"></i>Adicionar Lançamento
					</a>
				</div>
			<% } else { %>
				<div class="lancamentos-list">
					<% 
					int count = 0;
					for (Lancamento l : lancamentos) { 
						if (count >= 10) break; // Mostrar apenas os 10 últimos
						count++;
					%>
					<div class="lancamento-item <%= l.getTipo().equalsIgnoreCase("receita") ? "receita" : "despesa" %>">
						<div class="lancamento-info">
							<div class="lancamento-icon">
								<i class="fas fa-<%= l.getTipo().equalsIgnoreCase("receita") ? "arrow-up" : "arrow-down" %>"></i>
							</div>
							<div>
								<div class="lancamento-titulo"><%= l.getTitulo() %></div>
								<div class="lancamento-categoria">
									<i class="fas fa-tag me-1"></i>
									<%= l.getCategoria() != null ? l.getCategoria() : "Sem categoria" %>
								</div>
							</div>
						</div>
						<div class="lancamento-valor <%= l.getTipo().equalsIgnoreCase("receita") ? "receita" : "despesa" %>">
							<%= l.getTipo().equalsIgnoreCase("receita") ? "+" : "-" %> R$ <%= String.format("%.2f", l.getValor()) %>
						</div>
					</div>
					<% } %>
				</div>
				
				<% if (lancamentos.size() > 10) { %>
				<div style="text-align: center; margin-top: 1.5rem;">
					<a href="lancamentos.jsp" class="btn btn-add-small">
						<i class="fas fa-list me-2"></i>Ver Todos os Lançamentos
					</a>
				</div>
				<% } %>
			<% } %>
		</div>

		<!-- ========================= AÇÕES RÁPIDAS ========================= -->
		<div class="section-latest">
			<h2>
				<i class="fas fa-bolt me-2"></i>Ações Rápidas
			</h2>
			<div class="acoes-rapidas">
				<a href="lancamento.jsp" class="acao-card">
					<div class="acao-icon receitas">
						<i class="fas fa-plus-circle"></i>
					</div>
					<h4>Adicionar Lançamento</h4>
					<p>Registre uma nova receita ou despesa</p>
				</a>

				<a href="lista-desejos.jsp" class="acao-card">
					<div class="acao-icon desejos">
						<i class="fas fa-heart"></i>
					</div>
					<h4>Lista de Desejos</h4>
					<p>Gerencie seus objetivos e desejos</p>
				</a>

				<a href="PerfilServlet" class="acao-card">
					<div class="acao-icon perfil">
						<i class="fas fa-user-circle"></i>
					</div>
					<h4>Meu Perfil</h4>
					<p>Visualize e edite suas informações</p>
				</a>
			</div>
		</div>
		
	</main>
	<jsp:include page="footer.jsp" />
	<!-- Botão de scroll to top -->
	<button id="scrollToTop" class="scroll-top-btn" onclick="scrollToTop()">
		<i class="fas fa-arrow-up"></i>
	</button>

	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
	<script src="js/navbar.js"></script>
	<script>
		var receitaMensal = <%= receitaMensal %>;
		var despesaMensal = <%= despesaMensal %>;
	</script>
	<script src="js/Home.js"></script>
</body>
</html>