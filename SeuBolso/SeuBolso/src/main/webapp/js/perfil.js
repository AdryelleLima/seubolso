// ========================= INICIALIZAÇÃO =========================
document.addEventListener('DOMContentLoaded', function() {
    inicializarGrafico();
});

// ========================= GRÁFICO DE PIZZA =========================
function inicializarGrafico() {
    const ctx = document.getElementById('grafico-financeiro');
    if (!ctx) return;

    // Usar os dados do mês atual se disponíveis, senão usar os totais gerais
    const receitas = typeof totalReceitasMesAtual !== 'undefined' ? totalReceitasMesAtual : (typeof totalReceitas !== 'undefined' ? totalReceitas : 0);
    const despesas = typeof totalDespesasMesAtual !== 'undefined' ? totalDespesasMesAtual : (typeof totalDespesas !== 'undefined' ? totalDespesas : 0);

    if (receitas === 0 && despesas === 0) {
        ctx.parentElement.innerHTML = `
            <div class="empty-state">
                <i class="fas fa-chart-pie fa-3x mb-3"></i>
                <h4>Nenhum dado financeiro</h4>
                <p>Adicione receitas e despesas para visualizar o gráfico</p>
            </div>
        `;
        return;
    }

    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Receitas', 'Despesas'],
            datasets: [{
                data: [receitas, despesas],
                backgroundColor: [
                    'rgba(39, 174, 96, 0.9)',
                    'rgba(231, 76, 60, 0.9)'
                ],
                borderColor: [
                    'rgba(255, 255, 255, 1)',
                    'rgba(255, 255, 255, 1)'
                ],
                borderWidth: 3
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        padding: 15,
                        font: {
                            size: 13,
                            weight: '600'
                        },
                        color: '#2c3e50'
                    }
                },
                tooltip: {
                    backgroundColor: 'rgba(44, 62, 80, 0.95)',
                    titleFont: {
                        size: 14,
                        weight: 'bold'
                    },
                    bodyFont: {
                        size: 13
                    },
                    padding: 12,
                    callbacks: {
                        label: function(context) {
                            const label = context.label || '';
                            const value = context.parsed || 0;
                            const total = context.dataset.data.reduce((a, b) => a + b, 0);
                            const percentage = total > 0 ? ((value / total) * 100).toFixed(1) : 0;
                            return `${label}: R$ ${value.toLocaleString('pt-BR', {minimumFractionDigits: 2, maximumFractionDigits: 2})} (${percentage}%)`;
                        }
                    }
                }
            }
        }
    });
}

// ========================= ATUALIZAR FOTO DE PERFIL =========================
function updateFotoPerfil(input) {
    if (input.files && input.files[0]) {
        const file = input.files[0];
        
        // Validar tamanho (máximo 5MB)
        if (file.size > 5 * 1024 * 1024) {
            showToast('Erro: A imagem deve ter no máximo 5MB', 'error');
            return;
        }
        
        // Validar tipo
        if (!file.type.match('image.*')) {
            showToast('Erro: Apenas imagens são permitidas', 'error');
            return;
        }
        
        const reader = new FileReader();
        reader.onload = function(e) {
            const base64Image = e.target.result;
            
            // Atualizar preview
            document.getElementById('avatar-img').src = base64Image;
            
            // Enviar para o servidor
            fetch('PerfilServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `acao=atualizarFoto&fotoPerfil=${encodeURIComponent(base64Image)}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast('Foto de perfil atualizada com sucesso!', 'success');
                } else {
                    showToast('Erro ao atualizar foto: ' + (data.message || 'Erro desconhecido'), 'error');
                }
            })
            .catch(error => {
                console.error('Erro:', error);
                showToast('Erro ao atualizar foto de perfil', 'error');
            });
        };
        reader.readAsDataURL(file);
    }
}

// ========================= EDITAR NOME =========================
function editarNome() {
    const modal = new bootstrap.Modal(document.getElementById('edit-nome-modal'));
    modal.show();
}

function salvarNome() {
    const novoNome = document.getElementById('edit-nome-input').value.trim();
    
    if (!novoNome) {
        showToast('O nome não pode estar vazio', 'error');
        return;
    }
    
    fetch('PerfilServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `acao=atualizarNome&nome=${encodeURIComponent(novoNome)}`
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            document.getElementById('perfil-nome').textContent = novoNome;
            bootstrap.Modal.getInstance(document.getElementById('edit-nome-modal')).hide();
            showToast('Nome atualizado com sucesso!', 'success');
        } else {
            showToast('Erro ao atualizar nome: ' + (data.message || 'Erro desconhecido'), 'error');
        }
    })
    .catch(error => {
        console.error('Erro:', error);
        showToast('Erro ao atualizar nome', 'error');
    });
}

// ========================= EDITAR OBJETIVO =========================
function editarObjetivo() {
    const modal = new bootstrap.Modal(document.getElementById('edit-objetivo-modal'));
    modal.show();
}

function salvarObjetivo() {
    const novoObjetivo = document.getElementById('edit-objetivo-input').value;
    
    if (!novoObjetivo || parseFloat(novoObjetivo) < 0) {
        showToast('Valor inválido', 'error');
        return;
    }
    
    fetch('PerfilServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `acao=atualizarObjetivo&objetivoFinanceiro=${novoObjetivo}`
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            bootstrap.Modal.getInstance(document.getElementById('edit-objetivo-modal')).hide();
            showToast('Meta financeira atualizada com sucesso!', 'success');
            setTimeout(() => location.reload(), 1000);
        } else {
            showToast('Erro ao atualizar meta: ' + (data.message || 'Erro desconhecido'), 'error');
        }
    })
    .catch(error => {
        console.error('Erro:', error);
        showToast('Erro ao atualizar meta financeira', 'error');
    });
}

// ========================= EDITAR VALOR GUARDADO =========================
function editarGuardado() {
    const modal = new bootstrap.Modal(document.getElementById('edit-guardado-modal'));
    modal.show();
}

function salvarGuardado() {
    const novoGuardado = document.getElementById('edit-guardado-input').value;
    
    if (!novoGuardado || parseFloat(novoGuardado) < 0) {
        showToast('Valor inválido', 'error');
        return;
    }
    
    fetch('PerfilServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `acao=atualizarGuardado&valorGuardado=${novoGuardado}`
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            bootstrap.Modal.getInstance(document.getElementById('edit-guardado-modal')).hide();
            showToast('Valor guardado atualizado com sucesso!', 'success');
            setTimeout(() => location.reload(), 1000);
        } else {
            showToast('Erro ao atualizar valor: ' + (data.message || 'Erro desconhecido'), 'error');
        }
    })
    .catch(error => {
        console.error('Erro:', error);
        showToast('Erro ao atualizar valor guardado', 'error');
    });
}

// ========================= TOAST =========================
function showToast(message, type = 'info') {
    const toastContainer = document.getElementById('toast-container');
    const toastId = 'toast-' + Date.now();
    
    const bgColor = type === 'success' ? 'bg-success' : type === 'error' ? 'bg-danger' : 'bg-info';
    const icon = type === 'success' ? 'fa-check-circle' : type === 'error' ? 'fa-exclamation-circle' : 'fa-info-circle';
    
    const toastHTML = `
        <div id="${toastId}" class="toast align-items-center text-white ${bgColor} border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body">
                    <i class="fas ${icon} me-2"></i>${message}
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
    `;
    
    toastContainer.insertAdjacentHTML('beforeend', toastHTML);
    
    const toastElement = document.getElementById(toastId);
    const toast = new bootstrap.Toast(toastElement, {
        autohide: true,
        delay: 3000
    });
    
    toast.show();
    
    toastElement.addEventListener('hidden.bs.toast', function() {
        toastElement.remove();
    });
}