<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="models.Usuario"%>
<%
Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
if (usuario == null) {
	response.sendRedirect("login.jsp");
	return;
}

// Se não há dados carregados, redireciona para o servlet
if (request.getAttribute("totalReceitas") == null) {
	response.sendRedirect("PerfilServlet");
	return;
}
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Meu Perfil - SeuBolso</title>

<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
	rel="stylesheet" />
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet" />
<link href="css/main.css" rel="stylesheet" />
<link href="css/perfil.css" rel="stylesheet" />
</head>
<body>
	<jsp:include page="navbar.jsp" />

	<main class="main-container">
		<h2
			style="text-align: center; color: #2c3e50; margin-bottom: 2rem; font-size: 2.2rem;">
			<i class="fas fa-user-circle me-2"></i>Meu Perfil
		</h2>

		<!-- ========================= CARD DE PERFIL ========================= -->
		<div class="section-form">
			<div class="perfil-header">
				<div class="perfil-avatar-container">
					<div class="perfil-avatar">
						<c:choose>
							<c:when test="${not empty usuario.fotoPerfil}">
								<img src="${usuario.fotoPerfil}" alt="Foto de perfil"
									id="avatar-img">
							</c:when>
							<c:otherwise>
								<img src="img/logo.png" alt="Avatar padrão" id="avatar-img">
							</c:otherwise>
						</c:choose>
					</div>
					<button class="btn-change-photo"
						onclick="document.getElementById('foto-input').click()">
						<i class="fas fa-camera"></i>
					</button>
					<input type="file" id="foto-input" accept="image/*"
						style="display: none;" onchange="updateFotoPerfil(this)">
				</div>

				<div class="perfil-info">
					<div class="perfil-nome-group">
						<h3 id="perfil-nome"><%=usuario.getNome()%></h3>
						<button class="btn-edit-inline" onclick="editarNome()">
							<i class="fas fa-pen"></i>
						</button>
					</div>
					<p class="perfil-email">
						<i class="fas fa-envelope me-2"></i><%=usuario.getEmail()%>
					</p>
				</div>
			</div>
		</div>

		<!-- ========================= OBJETIVOS FINANCEIROS ========================= -->
		<div class="section-latest">
			<h2>
				<i class="fas fa-chart-line me-2"></i>Objetivos Financeiros
			</h2>

			<div class="objetivos-grid">
				<div class="objetivo-card">
					<div class="objetivo-header">
						<div>
							<i class="fas fa-bullseye objetivo-icon"></i>
							<h4>Meta Financeira</h4>
						</div>
						<button class="btn-edit-inline" onclick="editarObjetivo()">
							<i class="fas fa-pen"></i>
						</button>
					</div>
					<p class="objetivo-valor" id="objetivo-valor">
						<fmt:formatNumber value="${usuario.objetivoFinanceiro}"
							type="currency" currencySymbol="R$" />
					</p>
				</div>

				<div class="objetivo-card">
					<div class="objetivo-header">
						<div>
							<i class="fas fa-piggy-bank objetivo-icon"></i>
							<h4>Valor Guardado</h4>
						</div>
						<button class="btn-edit-inline" onclick="editarGuardado()">
							<i class="fas fa-pen"></i>
						</button>
					</div>
					<p class="objetivo-valor guardado" id="guardado-valor">
						<fmt:formatNumber value="${usuario.valorGuardado}" type="currency"
							currencySymbol="R$" />
					</p>
				</div>
			</div>

			<!-- Progresso -->
			<c:if test="${usuario.objetivoFinanceiro > 0}">
				<div class="progress-objetivo-container">
					<div class="progress-label">
						<span><i class="fas fa-chart-line me-1"></i>Progresso da
							Meta</span> <span class="progress-percentage"> <strong>
								<fmt:formatNumber
									value="${(usuario.valorGuardado / usuario.objetivoFinanceiro) * 100}"
									maxFractionDigits="1" />%
						</strong>
						</span>
					</div>
					<div class="progress">
						<div
							class="progress-bar progress-bar-striped progress-bar-animated"
							role="progressbar"
							style="width: ${(usuario.valorGuardado / usuario.objetivoFinanceiro) * 100}%"
							aria-valuenow="${(usuario.valorGuardado / usuario.objetivoFinanceiro) * 100}"
							aria-valuemin="0" aria-valuemax="100"></div>
					</div>
				</div>
			</c:if>
		</div>

		<!-- ========================= RESUMO FINANCEIRO ========================= -->
		<div class="section-latest">
			<h2>
				<i class="fas fa-wallet me-2"></i>Resumo Financeiro - Mês Atual
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
								<fmt:formatNumber value="${totalReceitasMesAtual}"
									type="currency" currencySymbol="R$" />
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
								<fmt:formatNumber value="${totalDespesasMesAtual}"
									type="currency" currencySymbol="R$" />
							</p>
						</div>
					</div>

					<div class="resumo-card saldo">
						<div class="resumo-icon">
							<i class="fas fa-balance-scale"></i>
						</div>
						<div class="resumo-info">
							<h4>Saldo do Mês</h4>
							<p class="resumo-valor">
								<fmt:formatNumber
									value="${totalReceitasMesAtual - totalDespesasMesAtual}"
									type="currency" currencySymbol="R$" />
							</p>
						</div>
					</div>
				</div>

				<!-- Coluna do Gráfico -->
				<div class="grafico-container">
					<h3>
						<i class="fas fa-chart-pie me-2"></i>Distribuição do Mês
					</h3>
					<canvas id="grafico-financeiro"></canvas>
				</div>
			</div>
		</div>

		<!-- ========================= LISTA DE DESEJOS (TOP 2) ========================= -->
		<div class="section-latest">
			<h2>
				<i class="fas fa-heart me-2"></i>Desejos Próximos de Realizar
			</h2>

			<c:choose>
				<c:when test="${empty topDesejos}">
					<div class="empty-state">
						<i class="fas fa-inbox fa-3x mb-3"></i>
						<h4>Nenhum desejo cadastrado</h4>
						<p>
							Acesse a <a href="lista-desejos.jsp">Lista de Desejos</a> para
							adicionar!
						</p>
					</div>
				</c:when>
				<c:otherwise>
					<div class="wishlist-grid">
						<c:forEach var="item" items="${topDesejos}" varStatus="status">
							<c:if test="${status.index < 2}">
								<div class="wishlist-card">
									<c:if test="${not empty item.imagemBase64}">
										<div class="card-image-container">
											<c:choose>
												<c:when test="${not empty item.link}">
													<a href="${item.link}" target="_blank"
														rel="noopener noreferrer"> <img
														src="${item.imagemBase64}" alt="${item.descricao}"
														class="card-image">
														<div class="image-overlay">
															<i class="fas fa-external-link-alt"></i>
														</div>
													</a>
												</c:when>
												<c:otherwise>
													<img src="${item.imagemBase64}" alt="${item.descricao}"
														class="card-image">
												</c:otherwise>
											</c:choose>
										</div>
									</c:if>

									<div class="card-content">
										<div class="card-header">
											<h5 class="card-title">
												<c:choose>
													<c:when test="${not empty item.link}">
														<a href="${item.link}" target="_blank"
															rel="noopener noreferrer"> ${item.descricao} <i
															class="fas fa-external-link-alt ms-1"
															style="font-size: 0.8em;"></i>
														</a>
													</c:when>
													<c:otherwise>
                                                        ${item.descricao}
                                                    </c:otherwise>
												</c:choose>
											</h5>
										</div>

										<div class="card-value">
											<i class="fas fa-tag me-2"></i>
											<fmt:formatNumber value="${item.valorObjetivo}"
												type="currency" currencySymbol="R$" />
										</div>

										<div class="progress-container">
											<div class="progress-label">
												<span><i class="fas fa-chart-line me-1"></i>Progresso</span>
												<span class="progress-percentage"><strong>${item.progresso}%</strong></span>
											</div>
											<div class="progress">
												<div
													class="progress-bar progress-bar-striped progress-bar-animated"
													role="progressbar" style="width: ${item.progresso}%"
													aria-valuenow="${item.progresso}" aria-valuemin="0"
													aria-valuemax="100"></div>
											</div>
										</div>
									</div>
								</div>
							</c:if>
						</c:forEach>
					</div>
					<div style="text-align: center; margin-top: 1.5rem;">
						<a href="lista-desejos.jsp" class="btn btn-add"> <i
							class="fas fa-heart me-2"></i>Ver Todos os Desejos
						</a>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</main>

	<!-- ========================= MODAL EDITAR NOME ========================= -->
	<div class="modal fade" id="edit-nome-modal" tabindex="-1"
		aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">
						<i class="fas fa-user me-2"></i>Editar Nome
					</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<div class="mb-3">
						<label for="edit-nome-input" class="form-label">Novo Nome</label>
						<input type="text" class="form-control" id="edit-nome-input"
							value="<%=usuario.getNome()%>">
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">
						<i class="fas fa-times me-1"></i>Cancelar
					</button>
					<button type="button" class="btn btn-primary"
						onclick="salvarNome()">
						<i class="fas fa-save me-1"></i>Salvar
					</button>
				</div>
			</div>
		</div>
	</div>

	<!-- ========================= MODAL EDITAR OBJETIVO ========================= -->
	<div class="modal fade" id="edit-objetivo-modal" tabindex="-1"
		aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">
						<i class="fas fa-bullseye me-2"></i>Editar Meta Financeira
					</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<div class="mb-3">
						<label for="edit-objetivo-input" class="form-label">Valor
							da Meta (R$)</label> <input type="number" class="form-control"
							id="edit-objetivo-input" step="0.01" min="0">
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">
						<i class="fas fa-times me-1"></i>Cancelar
					</button>
					<button type="button" class="btn btn-primary"
						onclick="salvarObjetivo()">
						<i class="fas fa-save me-1"></i>Salvar
					</button>
				</div>
			</div>
		</div>
	</div>

	<!-- ========================= MODAL EDITAR GUARDADO ========================= -->
	<div class="modal fade" id="edit-guardado-modal" tabindex="-1"
		aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">
						<i class="fas fa-piggy-bank me-2"></i>Editar Valor Guardado
					</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<div class="mb-3">
						<label for="edit-guardado-input" class="form-label">Valor
							Guardado (R$)</label> <input type="number" class="form-control"
							id="edit-guardado-input" step="0.01" min="0">
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">
						<i class="fas fa-times me-1"></i>Cancelar
					</button>
					<button type="button" class="btn btn-primary"
						onclick="salvarGuardado()">
						<i class="fas fa-save me-1"></i>Salvar
					</button>
				</div>
			</div>
		</div>
	</div>

	<!-- ========================= TOAST ========================= -->
	<div id="toast-container" class="position-fixed bottom-0 end-0 p-3"
		style="z-index: 1100"></div>

	<!-- ========================= SCRIPTS ========================= -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
	<script src="js/navbar.js"></script>

	<!-- Variáveis JavaScript -->
	<script>
		var usuarioId =
	<%=usuario.getId()%>
		;
		var totalReceitas =
	<%=request.getAttribute("totalReceitas") != null ? request.getAttribute("totalReceitas") : 0%>
		;
		var totalDespesas =
	<%=request.getAttribute("totalDespesas") != null ? request.getAttribute("totalDespesas") : 0%>
		;
		var totalReceitasMesAtual =
	<%=request.getAttribute("totalReceitasMesAtual") != null ? request.getAttribute("totalReceitasMesAtual") : 0%>
		;
		var totalDespesasMesAtual =
	<%=request.getAttribute("totalDespesasMesAtual") != null ? request.getAttribute("totalDespesasMesAtual") : 0%>
		;
	</script>

	<script src="js/perfil.js"></script>
</body>
</html>