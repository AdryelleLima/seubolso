<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Lista de Desejos - SeuBolso</title>

<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
	rel="stylesheet" />
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet" />
<link href="css/main.css" rel="stylesheet" />
<link href="css/lista-desejos.css" rel="stylesheet" />
</head>
<body>
	<jsp:include page="navbar.jsp" />

	<main class="main-container">
		<h2
			style="text-align: center; color: #2c3e50; margin-bottom: 2rem; font-size: 2.2rem;">
			<i class="fas fa-heart me-2"></i>Lista de Desejos
		</h2>

		<!-- ========================= FORMULÁRIO ========================= -->
		<div class="section-form">
			<div class="section-header">
				<h2>
					<i class="fas fa-gift me-2"></i>Adicionar Novo Desejo
				</h2>
			</div>

			<form action="ListaDesejosServlet" method="post"
				enctype="multipart/form-data" id="add-form">
				<input type="hidden" name="acao" value="adicionar">

				<div class="form-grid">
					<div class="form-field full-width">
						<label for="descricao"><i class="fas fa-tag me-1"></i>Descrição
							*</label> <input type="text" id="descricao" name="descricao" required
							placeholder="Ex: Notebook Dell Inspiron">
					</div>

					<div class="form-field">
						<label for="valorObjetivo"><i
							class="fas fa-dollar-sign me-1"></i>Valor Objetivo (R$) *</label> <input
							type="number" id="valorObjetivo" name="valorObjetivo" step="0.01"
							min="0.01" required placeholder="0.00">
					</div>
					<div class="form-field">
						<label for="valorAtual"><i class="fas fa-piggy-bank me-1"></i>Quanto
							já tenho guardado (R$)</label> <input type="number" id="valorAtual"
							name="valorAtual" step="0.01" min="0.00" placeholder="0.00">
					</div>


					<div class="form-field">
						<label for="link"><i class="fas fa-link me-1"></i>Link
							(Opcional)</label> <input type="url" id="link" name="link"
							placeholder="https://exemplo.com/produto">
					</div>

					<div class="form-field full-width">
						<label for="imagem"><i class="fas fa-image me-1"></i>Imagem
							(Opcional)</label> <input type="file" id="imagem" name="imagem"
							accept="image/*" class="form-control">
					</div>
				</div>

				<div class="form-actions">
					<button type="submit" class="btn btn-add">
						<i class="fas fa-plus me-2"></i>Adicionar à Lista
					</button>
					<button type="reset" class="btn btn-clear">
						<i class="fas fa-eraser me-2"></i>Limpar
					</button>
				</div>
			</form>
		</div>

		<!-- ========================= LISTA DE DESEJOS ========================= -->
		<div class="section-latest">
			<h2>
				<i class="fas fa-heart me-2"></i>Meus Desejos
			</h2>

			<c:choose>
				<c:when test="${empty listaDesejos}">
					<div class="empty-state">
						<i class="fas fa-inbox fa-3x mb-3"></i>
						<h4>Nenhum item na lista</h4>
						<p>Adicione seu primeiro desejo acima!</p>
					</div>
				</c:when>
				<c:otherwise>
					<div class="wishlist-grid">
						<c:forEach var="item" items="${listaDesejos}">
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

									<div class="card-actions">
										<button class="btn btn-sm btn-edit"
											onclick="openEditModal(${item.id}, '${item.descricao}', ${item.valorObjetivo}, ${item.valorAtual}, '${item.link}')">
											<i class="fas fa-edit me-1"></i>Editar
										</button>

										<button class="btn btn-sm btn-delete"
											onclick="deleteItem(${item.id}, '${item.descricao}')">
											<i class="fas fa-trash me-1"></i>Excluir
										</button>
									</div>
								</div>
							</div>
						</c:forEach>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</main>
	
	<jsp:include page="footer.jsp" />
	
	<!-- ========================= MODAL DE EDIÇÃO ========================= -->
	<div class="modal fade" id="edit-modal" tabindex="-1"
		aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">
						<i class="fas fa-edit me-2"></i>Editar Item
					</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>

				<form action="ListaDesejosServlet" method="post"
					enctype="multipart/form-data" id="edit-form">
					<div class="modal-body">
						<input type="hidden" name="acao" value="editar"> <input
							type="hidden" name="id" id="edit-id">

						<div class="mb-3">
							<label for="edit-descricao" class="form-label"> <i
								class="fas fa-tag me-1"></i>Descrição *
							</label> <input type="text" class="form-control" id="edit-descricao"
								name="descricao" required>
						</div>

						<div class="mb-3">
							<label for="edit-valorObjetivo" class="form-label"> <i
								class="fas fa-dollar-sign me-1"></i>Valor Objetivo (R$) *
							</label> <input type="number" class="form-control"
								id="edit-valorObjetivo" name="valorObjetivo" step="0.01"
								min="0.01" required>
						</div>
						<div class="mb-3">
							<label for="edit-valorAtual" class="form-label"> <i
								class="fas fa-piggy-bank me-1"></i>Quanto já tenho guardado (R$)
							</label> <input type="number" class="form-control" id="edit-valorAtual"
								name="valorAtual" step="0.01" min="0.00">
						</div>

						<div class="mb-3">
							<label for="edit-link" class="form-label"> <i
								class="fas fa-link me-1"></i>Link (Opcional)
							</label> <input type="url" class="form-control" id="edit-link"
								name="link">
						</div>

						<div class="mb-3">
							<label for="edit-imagem" class="form-label"> <i
								class="fas fa-image me-1"></i>Nova Imagem (Opcional)
							</label> <input type="file" class="form-control" id="edit-imagem"
								name="imagem" accept="image/*"> <small
								class="text-muted">Deixe em branco para manter a imagem
								atual</small>
						</div>
					</div>

					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">
							<i class="fas fa-times me-1"></i>Cancelar
						</button>
						<button type="submit" class="btn btn-primary">
							<i class="fas fa-save me-1"></i>Salvar Alterações
						</button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<!-- ========================= TOAST ========================= -->
	<div id="toast-container" class="position-fixed bottom-0 end-0 p-3"
		style="z-index: 1100"></div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<script src="js/navbar.js"></script>
	<script src="js/lista-desejos.js"></script>
</body>
</html>