<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.Usuario, models.Lancamento, java.util.List, java.text.DecimalFormat"%>
<%
// Verifica se o usuário está logado
Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
if (usuarioLogado == null) {
	response.sendRedirect("login.jsp");
	return;
}

// Recupera lista de lançamentos
List<Lancamento> lancamentos = (List<Lancamento>) request.getAttribute("lancamentos");

// Se lancamentos é null, significa que a página foi acessada diretamente
// Redireciona para o servlet
if (lancamentos == null) {
	response.sendRedirect("RelatorioServlet");
	return;
}

double totalReceitas = 0;
double totalDespesas = 0;
java.util.Set<String> categorias = new java.util.LinkedHashSet<>();

if (lancamentos != null) {
	for (Lancamento l : lancamentos) {
		if ("receita".equalsIgnoreCase(l.getTipo()))
			totalReceitas += l.getValor();
		else if ("despesa".equalsIgnoreCase(l.getTipo()))
			totalDespesas += l.getValor();
		if (l.getCategoria() != null && !l.getCategoria().isEmpty()) {
			categorias.add(l.getCategoria());
		}
	}
}

double saldoAtual = totalReceitas - totalDespesas;
DecimalFormat df = new DecimalFormat("#,##0.00");
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Relatório Financeiro - SeuBolso</title>

<!-- CSS -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet" />
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
<link href="css/main.css" rel="stylesheet" />
<link href="css/relatorio.css" rel="stylesheet" />

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
</head>
<body>
	<!-- Navbar -->
	<jsp:include page="navbar.jsp" />

	<main class="relatorio-main">
		<div class="conteudo">
			<h2>📊 Relatórios Financeiros</h2>

			<!-- Filtros -->
			<div class="filter-box">
				<div class="filter-field">
					<label for="start-date">Data Inicial:</label>
					<input id="start-date" type="date" />
				</div>
				<div class="filter-field">
					<label for="end-date">Data Final:</label>
					<input id="end-date" type="date" />
				</div>
				<div class="filter-field">
					<label for="filter-category">Categoria:</label>
					<select id="filter-category">
						<option value="">Todas</option>
						<%for (String cat : categorias) {%>
						<option value="<%=cat%>"><%=cat%></option>
						<%}%>
					</select>
				</div>
				<div class="filter-field">
					<label for="filter-type">Tipo:</label>
					<select id="filter-type">
						<option value="">Todos</option>
						<option value="receita">Receitas</option>
						<option value="despesa">Despesas</option>
					</select>
				</div>
				<div class="filter-actions">
					<button id="filter-report" type="button" class="btn-primary">🔍 Filtrar</button>
					<button id="clear-filter" type="button" class="btn-secondary">🔄 Limpar</button>
					<button id="export-excel" type="button" class="btn-success">📥 Exportar Excel</button>
				</div>
			</div>

			<!-- Resumo com Cards -->
			<div class="summary-cards">
				<div class="summary-card receitas">
					<div class="card-icon">💰</div>
					<div class="card-info">
						<div class="card-label">Total de Receitas</div>
						<div class="card-value" id="total-receitas">R$ <%=df.format(totalReceitas)%></div>
					</div>
				</div>

				<div class="summary-card despesas">
					<div class="card-icon">💸</div>
					<div class="card-info">
						<div class="card-label">Total de Despesas</div>
						<div class="card-value" id="total-despesas">R$ <%=df.format(totalDespesas)%></div>
					</div>
				</div>

				<div class="summary-card saldo <%=saldoAtual >= 0 ? "positivo" : "negativo"%>">
					<div class="card-icon"><%=saldoAtual >= 0 ? "✅" : "⚠️"%></div>
					<div class="card-info">
						<div class="card-label">Saldo do Período</div>
						<div class="card-value" id="saldo-periodo">R$ <%=df.format(saldoAtual)%></div>
					</div>
				</div>
			</div>

			<!-- Container com Grid para Gráfico e Histórico -->
			<div class="content-grid">
				<!-- Gráfico de Pizza -->
				<div class="chart-container">
					<h3>📈 Distribuição Financeira</h3>
					<div class="chart-wrapper">
						<canvas id="pieChart"></canvas>
					</div>
				</div>

				<!-- Histórico -->
				<div class="history-container">
					<h3>📋 Histórico de Transações</h3>
					<div class="history-list">
						<div class="history-columns">
							<div>Descrição</div>
							<div>Categoria</div>
							<div>Valor</div>
							<div>Data</div>
							<div>Tipo</div>
							<div>Ações</div>
						</div>
						<div id="report-history">
							<%if (lancamentos.isEmpty()) {%>
							<div class="no-data">Nenhum lançamento encontrado no período.</div>
							<%} else {
								for (Lancamento l : lancamentos) {
									Long id = l.getId();
									String titulo = l.getTitulo();
									String tituloEscapado = titulo != null ? titulo.replace("'", "\\'") : "";
							%>
							<div class="history-item <%=l.getTipo()%>" data-id="<%=id%>">
								<div><%=titulo%></div>
								<div><%=l.getCategoria() != null ? l.getCategoria() : "-"%></div>
								<div class="valor">R$ <%=df.format(Math.abs(l.getValor()))%></div>
								<div><%=l.getData()%></div>
								<div><span class="badge badge-<%=l.getTipo()%>"><%=l.getTipo()%></span></div>
								<div class="action-buttons">
									<button class="btn-icon btn-edit" onclick="abrirModalEditar(<%=id%>)" title="Editar">
										<i class="fas fa-edit"></i>
									</button>
									<button class="btn-icon btn-delete" onclick="excluirLancamento(<%=id%>, '<%=tituloEscapado%>')" title="Excluir">
										<i class="fas fa-trash"></i>
									</button>
								</div>
							</div>
							<%}}%>
						</div>
					</div>
				</div>
			</div>
		</div>
	</main>
	
	<jsp:include page="footer.jsp" />
	<!-- MODAL DE EDIÇÃO -->
	<div class="modal fade" id="modal-editar" tabindex="-1" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h3 class="modal-title">✏️ Editar Lançamento</h3>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fechar"></button>
				</div>
				<div class="modal-body">
					<form id="form-editar">
						<input type="hidden" id="edit-id" name="id">
						<input type="hidden" id="edit-tipo" name="tipo">
						<input type="hidden" id="usuarioId" name="usuarioId" value="<%=usuarioLogado.getId()%>">

						<div class="row g-3">
							<div class="col-md-6">
								<label for="edit-titulo" class="form-label">Título *</label>
								<input id="edit-titulo" name="titulo" type="text" class="form-control" required>
							</div>
							<div class="col-md-6">
								<label for="edit-valor" class="form-label">Valor (R$) *</label>
								<input id="edit-valor" name="valor" type="number" step="0.01" class="form-control" required>
							</div>
							<div class="col-md-6">
								<label for="edit-categoria" class="form-label">Categoria *</label>
								<input id="edit-categoria" name="categoria" type="text" class="form-control" required>
							</div>
							<div class="col-md-6">
								<label for="edit-data" class="form-label">Data *</label>
								<input id="edit-data" name="data" type="date" class="form-control" required>
							</div>
							<div class="col-md-6">
								<label for="edit-formaPagamento" class="form-label">Forma de Pagamento</label>
								<input id="edit-formaPagamento" name="formaPagamento" type="text" class="form-control">
							</div>
							<div class="col-md-6" id="edit-campo-vencimento">
								<label for="edit-vencimento" class="form-label">Vencimento</label>
								<input id="edit-vencimento" name="vencimento" type="date" class="form-control">
							</div>
							<div class="col-12">
								<label for="edit-descricao" class="form-label">Descrição</label>
								<textarea id="edit-descricao" name="descricao" rows="3" class="form-control"></textarea>
							</div>
							<div class="col-12">
								<div class="form-check">
									<input class="form-check-input" type="checkbox" name="despesaFixa" id="edit-fixa">
									<label class="form-check-label" for="edit-fixa">Despesa Fixa</label>
								</div>
							</div>
						</div>

						<div class="modal-footer">
							<button type="submit" class="btn btn-success">
								<i class="fas fa-save"></i> Salvar Alterações
							</button>
							<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
								<i class="fas fa-times"></i> Cancelar
							</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>

	<!-- MODAL DE CONFIRMAÇÃO DE EXCLUSÃO -->
	<div class="modal fade" id="modal-confirmar-exclusao" tabindex="-1" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header border-0 pb-0">
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fechar"></button>
				</div>
				<div class="modal-body text-center pt-0">
					<div class="mb-3">
						<i class="fas fa-exclamation-triangle" style="font-size: 4rem; color: #e74c3c;"></i>
					</div>
					<h4 class="mb-3">Confirmar Exclusão</h4>
					<p class="mb-4">
						Tem certeza que deseja excluir o lançamento <br />
						<strong id="delete-lancamento-titulo"></strong>?
					</p>
					<div class="d-flex gap-2 justify-content-center">
						<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
							<i class="fas fa-times"></i> Cancelar
						</button>
						<button type="button" class="btn btn-danger" id="btn-confirmar-exclusao">
							<i class="fas fa-trash"></i> Excluir
						</button>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- Toast Bootstrap -->
	<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 2000">
		<div id="toast" class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
			<div class="d-flex">
				<div id="toast-body" class="toast-body">Mensagem do sistema</div>
				<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
			</div>
		</div>
	</div>

	<!-- Dados iniciais para JS -->
	<script>
        window.dadosIniciais = {
            totalReceitas: <%=totalReceitas%>,
            totalDespesas: <%=totalDespesas%>,
            saldo: <%=saldoAtual%>,
            lancamentos: [
                <%for (int i = 0; i < lancamentos.size(); i++) {
	Lancamento l = lancamentos.get(i);
	String tituloJson = l.getTitulo() != null ? l.getTitulo().replace("\\", "\\\\").replace("\"", "\\\"") : "";
	String categoriaJson = l.getCategoria() != null ? l.getCategoria().replace("\\", "\\\\").replace("\"", "\\\"") : "";
%>
                {
                    id: <%=l.getId()%>,
                    titulo: "<%=tituloJson%>",
                    valor: <%=l.getValor()%>,
                    data: "<%=l.getData()%>",
                    tipo: "<%=l.getTipo()%>",
                    categoria: "<%=categoriaJson%>"
                }<%=i < lancamentos.size() - 1 ? "," : ""%>
                <%}%>
            ]
        };
    </script>

	<!-- JS -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<script src="js/navbar.js"></script>
	<script src="js/relatorio.js"></script>
</body>
</html>