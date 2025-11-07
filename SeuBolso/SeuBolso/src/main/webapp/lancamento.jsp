<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="models.Usuario"%>
<%@ page import="models.Lancamento"%>
<%@ page import="java.util.List"%>
<%@ page import="dao.LancamentoDAO"%>
<%@ page import="util.JDBCUtil"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="java.text.DecimalFormat"%>

<%
Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
if (usuario == null) {
	response.sendRedirect("login.jsp");
	return;
}

DateTimeFormatter formato = DateTimeFormatter.ofPattern("dd/MM/yyyy");
DecimalFormat df = new DecimalFormat("#,##0.00");

List<Lancamento> lancamentosFixos;
List<Lancamento> ultimosLancamentos;
try (java.sql.Connection con = JDBCUtil.getConnection()) {
	LancamentoDAO dao = new LancamentoDAO(con);
	lancamentosFixos = dao.listarPorUsuarioEFixa(usuario, true);
	ultimosLancamentos = dao.listarPorUsuario(usuario);

	ultimosLancamentos.sort((a, b) -> Long.compare(b.getId(), a.getId()));

	if (ultimosLancamentos.size() > 5) {
		ultimosLancamentos = ultimosLancamentos.subList(0, 5);
	}
} catch (Exception e) {
	lancamentosFixos = java.util.Collections.emptyList();
	ultimosLancamentos = java.util.Collections.emptyList();
}
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Lançamentos - SeuBolso</title>

<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
	rel="stylesheet" />
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet" />
<link href="css/main.css" rel="stylesheet" />
<link href="css/lancamento.css" rel="stylesheet" />
</head>
<body>
	<jsp:include page="navbar.jsp" />

	<main class="lancamento-main">
		<div class="conteudo">
			<h2>💰 Gerenciar Lançamentos</h2>

			<!-- FORMULÁRIO -->
			<div class="form-container">
				<div class="form-header">
					<h3>Novo Lançamento</h3>

					<div class="type-selector">
						<input checked id="receita" name="tipo-visual" type="radio"
							value="receita" /> <label for="receita">Receita</label> <input
							id="despesa" name="tipo-visual" type="radio" value="despesa" />
						<label for="despesa">Despesa</label>
					</div>
				</div>

				<form id="form-lancamento" method="POST">
					<input type="hidden" id="usuarioId" name="usuarioId"
						value="<%=usuario.getId()%>"> <input type="hidden"
						id="tipo-hidden" name="tipo" value="receita">

					<div class="form-grid">
						<div class="form-field">
							<label for="titulo">Título *</label> <input id="titulo"
								name="titulo" type="text" placeholder="Ex: Salário" required />
						</div>
						<div class="form-field">
							<label for="valor">Valor (R$) *</label> <input id="valor"
								name="valor" type="number" step="0.01" placeholder="0,00"
								required />
						</div>
						<div class="form-field">
							<label for="categoria">Categoria *</label> <input id="categoria"
								name="categoria" type="text" placeholder="Ex: Alimentação"
								required />
						</div>
						<div class="form-field">
							<label for="data">Data *</label> <input id="data" name="data"
								type="date" required />
						</div>
						<div class="form-field">
							<label for="formaPagamento">Forma de Pagamento</label> <input
								id="formaPagamento" name="formaPagamento" type="text"
								placeholder="Ex: PIX, Cartão" />
						</div>
						<div class="form-field" id="campo-vencimento"
							style="display: none;">
							<label for="vencimento">Vencimento</label> <input id="vencimento"
								name="vencimento" type="date" />
						</div>
						<div class="form-field full-width">
							<label for="descricao">Descrição</label>
							<textarea id="descricao" name="descricao" rows="3"
								placeholder="Detalhes adicionais..."></textarea>
						</div>
						<div class="form-field" id="campo-fixa" style="display: none;">
							<label class="checkbox-label"> <input type="checkbox"
								name="despesaFixa" id="fixa" /> <span>Despesa Fixa
									(recorrente)</span>
							</label>
						</div>
					</div>

					<div class="form-actions">
						<button class="btn btn-add" id="btn-add" type="submit">
							<i class="fas fa-plus"></i> Adicionar Receita
						</button>
						<button class="btn btn-clear" type="reset">
							<i class="fas fa-eraser"></i> Limpar
						</button>
					</div>
				</form>
			</div>

			<!-- DESPESAS FIXAS -->
			<div class="history-container">
				<h3>📌 Despesas Fixas</h3>
				<div class="history-list">
					<div class="history-columns">
						<div>Título</div>
						<div>Categoria</div>
						<div>Valor</div>
						<div>Vencimento</div>
						<div>Forma Pgto</div>
						<div>Ações</div>
					</div>
					<div id="lista-fixas" class="history-items">
						<%
						if (lancamentosFixos.isEmpty()) {
						%>
						<div class="no-data">Nenhuma despesa fixa cadastrada.</div>
						<%
						} else {
						for (Lancamento l : lancamentosFixos) {
						%>
						<div class="history-item despesa" data-id="<%=l.getId()%>">
							<div>
								<i class="fas fa-repeat me-2"></i><%=l.getTitulo()%></div>
							<div>
								<span class="badge badge-categoria"><%=l.getCategoria()%></span>
							</div>
							<div class="valor-cell negative">
								<strong>- R$ <%=df.format(l.getValor())%></strong>
							</div>
							<div>
								<i class="fas fa-calendar-alt me-1"></i><%=l.getVencimento() != null ? l.getVencimento().format(formato) : "—"%></div>
							<div><%=l.getFormaPagamento() != null ? l.getFormaPagamento() : "—"%></div>
							<div class="action-buttons">
								<button class="btn-icon btn-edit"
									onclick="abrirModalEditar(<%=l.getId()%>)" title="Editar">
									<i class="fas fa-edit"></i>
								</button>
								<button class="btn-icon btn-delete"
									onclick="excluirLancamento(<%=l.getId()%>, '<%=l.getTitulo()%>')"
									title="Excluir">
									<i class="fas fa-trash"></i>
								</button>
							</div>
						</div>
						<%
						}
						}
						%>
					</div>
				</div>
			</div>

			<!-- ÚLTIMOS LANÇAMENTOS -->
			<div class="history-container">
				<h3>📋 Últimos Lançamentos</h3>
				<div class="history-list">
					<div class="history-columns">
						<div>Título</div>
						<div>Categoria</div>
						<div>Valor</div>
						<div>Data</div>
						<div>Forma Pgto</div>
						<div>Tipo</div>
						<div>Ações</div>
					</div>
					<div id="lista-ultimos" class="history-items">
						<%
						if (ultimosLancamentos.isEmpty()) {
						%>
						<div class="no-data">Nenhum lançamento cadastrado.</div>
						<%
						} else {
						for (Lancamento l : ultimosLancamentos) {
						%>
						<div class="history-item <%=l.getTipo()%>"
							data-id="<%=l.getId()%>">
							<div>
								<i
									class="fas <%=l.getTipo().equals("despesa") ? "fa-arrow-down" : "fa-arrow-up"%> me-2"></i><%=l.getTitulo()%></div>
							<div>
								<span class="badge badge-categoria"><%=l.getCategoria()%></span>
							</div>
							<div
								class="valor-cell <%=l.getTipo().equals("despesa") ? "negative" : "positive"%>">
								<strong><%=l.getTipo().equals("despesa") ? "-" : "+"%>
									R$ <%=df.format(l.getValor())%></strong>
							</div>
							<div>
								<i class="fas fa-calendar-alt me-1"></i><%=l.getData().format(formato)%></div>
							<div><%=l.getFormaPagamento() != null ? l.getFormaPagamento() : "—"%></div>
							<div>
								<span class="badge badge-<%=l.getTipo()%>"><%=l.getTipo()%></span>
							</div>
							<div class="action-buttons">
								<button class="btn-icon btn-edit"
									onclick="abrirModalEditar(<%=l.getId()%>)" title="Editar">
									<i class="fas fa-edit"></i>
								</button>
								<button class="btn-icon btn-delete"
									onclick="excluirLancamento(<%=l.getId()%>, '<%=l.getTitulo()%>')"
									title="Excluir">
									<i class="fas fa-trash"></i>
								</button>
							</div>
						</div>
						<%
						}
						}
						%>
					</div>
				</div>
			</div>
		</div>
	</main>
	
	<jsp:include page="footer.jsp" />
	
	<!-- MODAL DE EDIÇÃO -->
	<div class="modal fade" id="modal-editar" tabindex="-1"
		aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h3 class="modal-title">✏️ Editar Lançamento</h3>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Fechar"></button>
				</div>
				<div class="modal-body">
					<form id="form-editar">
						<!-- Hidden fields -->
						<input type="hidden" id="edit-id" name="id"> <input
							type="hidden" id="edit-tipo" name="tipo">

						<div class="row g-3">
							<div class="col-md-6">
								<label for="edit-titulo" class="form-label">Título *</label> <input
									id="edit-titulo" name="titulo" type="text" class="form-control"
									required>
							</div>
							<div class="col-md-6">
								<label for="edit-valor" class="form-label">Valor (R$) *</label>
								<input id="edit-valor" name="valor" type="number" step="0.01"
									class="form-control" required>
							</div>
							<div class="col-md-6">
								<label for="edit-categoria" class="form-label">Categoria
									*</label> <input id="edit-categoria" name="categoria" type="text"
									class="form-control" required>
							</div>
							<div class="col-md-6">
								<label for="edit-data" class="form-label">Data *</label> <input
									id="edit-data" name="data" type="date" class="form-control"
									required>
							</div>
							<div class="col-md-6">
								<label for="edit-formaPagamento" class="form-label">Forma
									de Pagamento</label> <input id="edit-formaPagamento"
									name="formaPagamento" type="text" class="form-control">
							</div>
							<div class="col-md-6" id="edit-campo-vencimento">
								<label for="edit-vencimento" class="form-label">Vencimento</label>
								<input id="edit-vencimento" name="vencimento" type="date"
									class="form-control">
							</div>
							<div class="col-12">
								<label for="edit-descricao" class="form-label">Descrição</label>
								<textarea id="edit-descricao" name="descricao" rows="3"
									class="form-control"></textarea>
							</div>
							<div class="col-12">
								<div class="form-check">
									<input class="form-check-input" type="checkbox"
										name="despesaFixa" id="edit-fixa"> <label
										class="form-check-label" for="edit-fixa">Despesa Fixa</label>
								</div>
							</div>
						</div>

						<div class="modal-footer">
							<button type="submit" class="btn btn-success">
								<i class="fas fa-save"></i> Salvar Alterações
							</button>
							<button type="button" class="btn btn-secondary"
								data-bs-dismiss="modal">
								<i class="fas fa-times"></i> Cancelar
							</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>

	<!-- MODAL DE CONFIRMAÇÃO DE EXCLUSÃO -->
	<div class="modal fade" id="modal-confirmar-exclusao" tabindex="-1"
		aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header border-0 pb-0">
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Fechar"></button>
				</div>
				<div class="modal-body text-center pt-0">
					<div class="mb-3">
						<i class="fas fa-exclamation-triangle"
							style="font-size: 4rem; color: #e74c3c;"></i>
					</div>
					<h4 class="mb-3">Confirmar Exclusão</h4>
					<p class="mb-4">
						Tem certeza que deseja excluir o lançamento <br />
						<strong id="delete-lancamento-titulo"></strong>?
					</p>
					<div class="d-flex gap-2 justify-content-center">
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">
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
		<div id="toast"
			class="toast align-items-center text-white bg-success border-0"
			role="alert" aria-live="assertive" aria-atomic="true">
			<div class="d-flex">
				<div id="toast-body" class="toast-body">Mensagem do sistema</div>
				<button type="button" class="btn-close btn-close-white me-2 m-auto"
					data-bs-dismiss="toast"></button>
			</div>
		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<script src="js/navbar.js"></script>
	<script src="js/lancamento.js"></script>
</body>
</html>