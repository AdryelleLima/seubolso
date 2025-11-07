// ========================= TOAST NOTIFICATION =========================
function showToast(mensagem, isSucesso) {
    var texto = mensagem || (isSucesso ? "Operação realizada com sucesso!" : "Ocorreu um erro inesperado.");
    var corClasse = isSucesso ? "success" : "danger";
    var icone = isSucesso ? "fa-check-circle" : "fa-exclamation-circle";
    
    var container = document.getElementById("toast-container");
    var el = document.createElement("div");
    
    el.className = "toast align-items-center text-bg-" + corClasse + " border-0";
    el.innerHTML = '<div class="d-flex">' +
                   '<div class="toast-body">' +
                   '<i class="fas ' + icone + ' me-2"></i>' + texto +
                   '</div>' +
                   '<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>' +
                   '</div>';
    
    container.appendChild(el);
    var toastInstance = new bootstrap.Toast(el);
    toastInstance.show();
    
    setTimeout(function() { 
        el.remove(); 
    }, 4000);
}

// ========================= MODAL DE EDIÇÃO =========================
let editModalInstance;

function openEditModal(id, descricao, valorObjetivo, valorAtual, link) {
    document.getElementById("edit-id").value = id;
    document.getElementById("edit-descricao").value = descricao || "";
    document.getElementById("edit-valorObjetivo").value = valorObjetivo || "";
    document.getElementById("edit-valorAtual").value = valorAtual || 0;
    document.getElementById("edit-link").value = link || "";
    document.getElementById("edit-imagem").value = "";

    const modalEl = document.getElementById("edit-modal");
    if (!editModalInstance) {
        editModalInstance = new bootstrap.Modal(modalEl);
    }
    editModalInstance.show();
}


function closeEditModal() {
    if (editModalInstance) {
        editModalInstance.hide();
    }
}

// ========================= DELETAR ITEM =========================
function deleteItem(id, descricao) {
    var modalHtml = '<div class="modal fade" id="delete-confirm-modal" tabindex="-1">' +
                    '<div class="modal-dialog modal-dialog-centered">' +
                    '<div class="modal-content">' +
                    '<div class="modal-header bg-danger text-white">' +
                    '<h5 class="modal-title">' +
                    '<i class="fas fa-exclamation-triangle me-2"></i>Confirmar Exclusão' +
                    '</h5>' +
                    '<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>' +
                    '</div>' +
                    '<div class="modal-body">' +
                    '<p class="mb-0">Tem certeza que deseja excluir <strong>"' + descricao + '"</strong>?</p>' +
                    '<p class="text-muted small mb-0 mt-2">Esta ação não pode ser desfeita.</p>' +
                    '</div>' +
                    '<div class="modal-footer">' +
                    '<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">' +
                    '<i class="fas fa-times me-1"></i>Cancelar' +
                    '</button>' +
                    '<button type="button" class="btn btn-danger" id="confirm-delete-btn">' +
                    '<i class="fas fa-trash me-1"></i>Excluir' +
                    '</button>' +
                    '</div>' +
                    '</div>' +
                    '</div>' +
                    '</div>';
    
    var modalContainer = document.createElement("div");
    modalContainer.innerHTML = modalHtml;
    document.body.appendChild(modalContainer);
    
    var deleteModal = new bootstrap.Modal(document.getElementById("delete-confirm-modal"));
    deleteModal.show();
    
    document.getElementById("confirm-delete-btn").addEventListener("click", function() {
        var formData = new FormData();
        formData.append("acao", "excluir");
        formData.append("id", id);
        
        fetch("ListaDesejosServlet", {
            method: "POST",
            body: formData
        })
        .then(function(response) {
            if (response.ok) {
                deleteModal.hide();
                showToast('"' + descricao + '" foi excluído com sucesso!', true);
                setTimeout(function() { 
                    location.reload(); 
                }, 1500);
            } else {
                throw new Error("Erro ao excluir item");
            }
        })
        .catch(function(error) {
            console.error("Erro:", error);
            showToast("Erro ao excluir item. Tente novamente.", false);
        });
    });
    
    document.getElementById("delete-confirm-modal").addEventListener("hidden.bs.modal", function() {
        modalContainer.remove();
    });
}

// ========================= SUBMIT DOS FORMULÁRIOS =========================
document.addEventListener("DOMContentLoaded", function() {
    var addForm = document.getElementById("add-form");
    if (addForm) {
        addForm.addEventListener("submit", function(e) {
            e.preventDefault();
            
            var formData = new FormData(addForm);
            var submitBtn = addForm.querySelector('button[type="submit"]');
            var originalText = submitBtn.innerHTML;
            
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Adicionando...';
            
            fetch(addForm.action, {
                method: "POST",
                body: formData
            })
            .then(function(response) {
                if (response.ok) {
                    showToast("Item adicionado com sucesso!", true);
                    setTimeout(function() { 
                        location.reload(); 
                    }, 1500);
                } else {
                    throw new Error("Erro ao adicionar item");
                }
            })
            .catch(function(error) {
                console.error("Erro:", error);
                showToast("Erro ao adicionar item. Tente novamente.", false);
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalText;
            });
        });
    }
    
    var editForm = document.getElementById("edit-form");
    if (editForm) {
        editForm.addEventListener("submit", function(e) {
            e.preventDefault();
            
            var formData = new FormData(editForm);
            var submitBtn = editForm.querySelector('button[type="submit"]');
            var originalText = submitBtn.innerHTML;
            
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Salvando...';
            
            fetch(editForm.action, {
                method: "POST",
                body: formData
            })
            .then(function(response) {
                if (response.ok) {
                    closeEditModal();
                    showToast("Item atualizado com sucesso!", true);
                    setTimeout(function() { 
                        location.reload(); 
                    }, 1500);
                } else {
                    throw new Error("Erro ao atualizar item");
                }
            })
            .catch(function(error) {
                console.error("Erro:", error);
                showToast("Erro ao atualizar item. Tente novamente.", false);
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalText;
            });
        });
    }
    
    var imagemInput = document.getElementById("imagem");
    if (imagemInput) {
        imagemInput.addEventListener("change", function(e) {
            var file = e.target.files[0];
            if (file && file.size > 5 * 1024 * 1024) {
                showToast("A imagem deve ter no máximo 5MB", false);
                imagemInput.value = "";
            }
        });
    }
    
    var editImagemInput = document.getElementById("edit-imagem");
    if (editImagemInput) {
        editImagemInput.addEventListener("change", function(e) {
            var file = e.target.files[0];
            if (file && file.size > 5 * 1024 * 1024) {
                showToast("A imagem deve ter no máximo 5MB", false);
                editImagemInput.value = "";
            }
        });
    }
});