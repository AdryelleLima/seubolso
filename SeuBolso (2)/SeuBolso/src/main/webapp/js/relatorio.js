document.addEventListener('DOMContentLoaded', function() {
    
    let chartInstance = null;
    const contextPath = "/SeuBolso";
    const endpoint = `${contextPath}/lancamentos`;
    
    // ===============================
    // BOOTSTRAP MODALS
    // ===============================
    const modalEl = document.getElementById("modal-editar");
    const modalExclusaoEl = document.getElementById("modal-confirmar-exclusao");
    let bsModal = null;
    let bsModalExclusao = null;
    
    if (modalEl && typeof bootstrap !== "undefined") {
        bsModal = new bootstrap.Modal(modalEl, { backdrop: "static" });
    }
    
    if (modalExclusaoEl && typeof bootstrap !== "undefined") {
        bsModalExclusao = new bootstrap.Modal(modalExclusaoEl);
    }
    
    let lancamentoParaExcluir = { id: null, titulo: "" };
    
    // ===============================
    // TOAST
    // ===============================
    function showToast(message, type) {
        type = type || "success";
        const bg = (type === "success") ? "bg-success text-white" : "bg-danger text-white";
        const wrapper = document.createElement("div");
        wrapper.className = "toast align-items-center " + bg + " border-0 show";
        wrapper.role = "alert";
        wrapper.style.minWidth = "220px";
        wrapper.innerHTML =
            '<div class="d-flex">' +
            '<div class="toast-body">' + message + '</div>' +
            '<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>' +
            '</div>';
        
        let container = document.querySelector('.toast-container');
        if (!container) {
            container = document.createElement('div');
            container.className = 'toast-container position-fixed bottom-0 end-0 p-3';
            container.style.zIndex = '2000';
            document.body.appendChild(container);
        }
        container.appendChild(wrapper);

        if (typeof bootstrap !== "undefined" && bootstrap.Toast) {
            const t = new bootstrap.Toast(wrapper, { delay: 3500 });
            t.show();
            wrapper.addEventListener("hidden.bs.toast", function () { wrapper.remove(); });
        } else {
            setTimeout(function () { wrapper.remove(); }, 3500);
        }
    }
    
    // ===============================
    // ABRIR MODAL EDITAR
    // ===============================
    window.abrirModalEditar = function (id) {
        if (!id || id === "undefined" || id === undefined || id === 0 || id === "0" || id === null) {
            showToast("Erro: ID do lançamento não foi encontrado.", "error");
            return;
        }
        
        const xhr = new XMLHttpRequest();
        xhr.open("GET", endpoint + "?action=buscar&id=" + encodeURIComponent(id), true);
        xhr.setRequestHeader("Accept", "application/json");

        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    try {
                        const lanc = JSON.parse(xhr.responseText);
                        
                        const f = {
                            id: document.getElementById("edit-id"),
                            titulo: document.getElementById("edit-titulo"),
                            valor: document.getElementById("edit-valor"),
                            categoria: document.getElementById("edit-categoria"),
                            data: document.getElementById("edit-data"),
                            formaPagamento: document.getElementById("edit-formaPagamento"),
                            descricao: document.getElementById("edit-descricao"),
                            tipo: document.getElementById("edit-tipo"),
                            vencimento: document.getElementById("edit-vencimento"),
                            fixa: document.getElementById("edit-fixa")
                        };

                        f.id.value = lanc.id || "";
                        f.titulo.value = lanc.titulo || "";
                        f.valor.value = Math.abs(lanc.valor) || "";
                        f.categoria.value = lanc.categoria || "";
                        f.data.value = lanc.data || "";
                        f.formaPagamento.value = lanc.formaPagamento || "";
                        f.descricao.value = lanc.descricao || "";
                        f.tipo.value = lanc.tipo ? lanc.tipo.toUpperCase() : "RECEITA";
                        f.vencimento.value = lanc.vencimento || "";
                        f.fixa.checked = !!lanc.despesaFixa;

                        if (bsModal) {
                            bsModal.show();
                        } else if (modalEl) {
                            modalEl.classList.add("show");
                            modalEl.style.display = "block";
                        }

                    } catch (e) {
                        showToast("Erro ao carregar dados do lançamento.", "error");
                    }
                } else {
                    showToast("Erro ao buscar lançamento.", "error");
                }
            }
        };
        xhr.send();
    };
    
    // ===============================
    // EXCLUIR LANÇAMENTO
    // ===============================
    window.excluirLancamento = function (id, titulo) {
        lancamentoParaExcluir.id = id;
        lancamentoParaExcluir.titulo = titulo;

        const tituloEl = document.getElementById("delete-lancamento-titulo");
        if (tituloEl) {
            tituloEl.textContent = '"' + titulo + '"';
        }

        if (bsModalExclusao) {
            bsModalExclusao.show();
        }
    };

    // Botão confirmar exclusão
    const btnConfirmarExclusao = document.getElementById("btn-confirmar-exclusao");
    if (btnConfirmarExclusao) {
        btnConfirmarExclusao.addEventListener("click", function () {
            const xhr = new XMLHttpRequest();
            xhr.open("POST", endpoint, true);
            xhr.setRequestHeader("Content-Type", "application/json");
            xhr.setRequestHeader("Accept", "application/json");

            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    let json;
                    try { json = JSON.parse(xhr.responseText); } catch (e) { json = null; }

                    if (bsModalExclusao) {
                        bsModalExclusao.hide();
                    }

                    if (xhr.status === 200 && json && json.status === "sucesso") {
                        showToast(json.mensagem || "Lançamento excluído.", "success");
                        setTimeout(function () { window.location.reload(); }, 700);
                    } else {
                        showToast((json && json.mensagem) || "Erro ao excluir.", "error");
                    }
                }
            };

            xhr.send(JSON.stringify({ action: "deletar", id: Number(lancamentoParaExcluir.id) }));
        });
    }
    
    // ===============================
    // EDITAR LANÇAMENTO
    // ===============================
    const formEdit = document.getElementById("form-editar");
    if (formEdit) {
        formEdit.addEventListener("submit", function (e) {
            e.preventDefault();

            const usuarioIdEl = document.getElementById("usuarioId");
            const usuarioId = usuarioIdEl ? Number(usuarioIdEl.value) : null;

            const tipo = (document.getElementById("edit-tipo").value || "RECEITA").toUpperCase();
            const valorEl = document.getElementById("edit-valor");
            
            let valorNumerico = Math.abs(Number(valorEl.value));
            if (tipo === "DESPESA") {
                valorNumerico = -valorNumerico;
            }

            const payload = {
                action: "atualizar",
                id: Number(document.getElementById("edit-id").value),
                titulo: document.getElementById("edit-titulo").value,
                valor: valorNumerico,
                categoria: document.getElementById("edit-categoria").value,
                data: document.getElementById("edit-data").value,
                formaPagamento: document.getElementById("edit-formaPagamento").value,
                descricao: document.getElementById("edit-descricao").value,
                tipo: tipo,
                vencimento: document.getElementById("edit-vencimento").value || "",
                despesaFixa: !!document.getElementById("edit-fixa") && document.getElementById("edit-fixa").checked,
                usuarioId: usuarioId
            };

            const xhr = new XMLHttpRequest();
            xhr.open("POST", endpoint, true);
            xhr.setRequestHeader("Content-Type", "application/json");
            xhr.setRequestHeader("Accept", "application/json");

            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    let json;
                    try { json = JSON.parse(xhr.responseText); } catch (e) { json = null; }
                    
                    if (xhr.status === 200 && json && json.mensagem) {
                        showToast(json.mensagem, "success");
                        if (bsModal) bsModal.hide();
                        setTimeout(function () { window.location.reload(); }, 700);
                    } else {
                        showToast((json && json.erro) || "Erro ao atualizar.", "error");
                    }
                }
            };
            xhr.send(JSON.stringify(payload));
        });
    }
    
    // ===============================
    // INICIALIZAR GRÁFICO DE PIZZA (ESTILO PERFIL)
    // ===============================
    function inicializarGrafico(receitas, despesas) {
        const ctx = document.getElementById('pieChart');
        if (!ctx) {
            return;
        }
        
        if (chartInstance) {
            chartInstance.destroy();
        }
        
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
        
        const receitasAbs = Math.abs(receitas);
        const despesasAbs = Math.abs(despesas);
        
        chartInstance = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Receitas', 'Despesas'],
                datasets: [{
                    data: [receitasAbs, despesasAbs],
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
    
    // Inicializa gráfico com dados carregados
    if (window.dadosIniciais) {
        inicializarGrafico(window.dadosIniciais.totalReceitas, Math.abs(window.dadosIniciais.totalDespesas));
    }
    
    // ===============================
    // FILTRAR RELATÓRIO
    // ===============================
    const btnFiltrar = document.getElementById('filter-report');
    if (btnFiltrar) {
        btnFiltrar.addEventListener('click', function() {
            const dataInicio = document.getElementById('start-date').value;
            const dataFim = document.getElementById('end-date').value;
            const categoria = document.getElementById('filter-category').value;
            const tipo = document.getElementById('filter-type').value;
            
            if (!dataInicio || !dataFim) {
                showToast('Por favor, selecione as datas de início e fim.', 'error');
                return;
            }
            
            if (new Date(dataInicio) > new Date(dataFim)) {
                showToast('A data inicial não pode ser maior que a data final.', 'error');
                return;
            }
            
            let url = 'RelatorioServlet?ajax=true&dataInicio=' + dataInicio + '&dataFim=' + dataFim;
            if (categoria) url += '&categoria=' + encodeURIComponent(categoria);
            if (tipo) url += '&tipo=' + tipo;
            
            const historyDiv = document.getElementById('report-history');
            if (historyDiv) {
                historyDiv.innerHTML = '<div class="loading">Carregando dados...</div>';
            }
            
            fetch(url)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Erro na resposta: ' + response.status);
                    }
                    return response.json();
                })
                .then(data => {
                    atualizarRelatorio(data);
                })
                .catch(error => {
                    showToast('Erro ao buscar dados. Tente novamente.', 'error');
                    if (historyDiv) {
                        historyDiv.innerHTML = '<div class="error">Erro ao carregar dados.</div>';
                    }
                });
        });
    }
    
    // ===============================
    // LIMPAR FILTROS
    // ===============================
    const btnLimpar = document.getElementById('clear-filter');
    if (btnLimpar) {
        btnLimpar.addEventListener('click', function() {
            window.location.href = 'RelatorioServlet';
        });
    }
    
    // ===============================
    // ATUALIZAR RELATÓRIO
    // ===============================
    function atualizarRelatorio(data) {
        const df = new Intl.NumberFormat('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        
        // Atualiza cards de resumo
        const totalReceitasEl = document.getElementById('total-receitas');
        const totalDespesasEl = document.getElementById('total-despesas');
        const saldoPeriodoEl = document.getElementById('saldo-periodo');
        
        if (totalReceitasEl) totalReceitasEl.textContent = 'R$ ' + df.format(data.totalReceitas);
        if (totalDespesasEl) totalDespesasEl.textContent = 'R$ ' + df.format(Math.abs(data.totalDespesas));
        if (saldoPeriodoEl) saldoPeriodoEl.textContent = 'R$ ' + df.format(data.saldo);
        
        // Atualiza cor do card de saldo
        const saldoCard = document.querySelector('.summary-card.saldo');
        if (saldoCard) {
            saldoCard.classList.remove('positivo', 'negativo');
            saldoCard.classList.add(data.saldo >= 0 ? 'positivo' : 'negativo');
            
            const icon = saldoCard.querySelector('.card-icon');
            if (icon) {
                icon.textContent = data.saldo >= 0 ? '✅' : '⚠️';
            }
        }
        
        // Atualiza gráfico
        inicializarGrafico(data.totalReceitas, Math.abs(data.totalDespesas));
        
        // Atualiza histórico
        const historyDiv = document.getElementById('report-history');
        if (!historyDiv) {
            return;
        }
        
        if (!data.lancamentos || data.lancamentos.length === 0) {
            historyDiv.innerHTML = '<div class="no-data">Nenhum lançamento encontrado no período.</div>';
            return;
        }
        
        historyDiv.innerHTML = '';
        data.lancamentos.forEach((lanc) => {
            const lancamentoId = lanc.id;
            
            if (!lancamentoId || lancamentoId === 0) {
                return;
            }
            
            const item = document.createElement('div');
            item.className = 'history-item ' + (lanc.tipo || 'receita').toLowerCase();
            item.setAttribute('data-id', lancamentoId);
            
            const tituloEscapado = (lanc.titulo || '').replace(/'/g, "\\'").replace(/"/g, '&quot;');
            
            item.innerHTML = `
                <div>${lanc.titulo || 'Sem título'}</div>
                <div>${lanc.categoria || '-'}</div>
                <div class="valor">R$ ${df.format(Math.abs(lanc.valor || 0))}</div>
                <div>${formatarData(lanc.data)}</div>
                <div><span class="badge badge-${(lanc.tipo || 'receita').toLowerCase()}">${lanc.tipo || 'receita'}</span></div>
                <div class="action-buttons">
                    <button class="btn-icon btn-edit" onclick="abrirModalEditar(${lancamentoId})" title="Editar">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn-icon btn-delete" onclick="excluirLancamento(${lancamentoId}, '${tituloEscapado}')" title="Excluir">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
            `;
            historyDiv.appendChild(item);
        });
    }
    
    // ===============================
    // EXPORTAR PARA EXCEL
    // ===============================
    const btnExport = document.getElementById('export-excel');
    if (btnExport) {
        btnExport.addEventListener('click', function() {
            const startDate = document.getElementById('start-date');
            const endDate = document.getElementById('end-date');
            const dataInicio = startDate ? startDate.value : '';
            const dataFim = endDate ? endDate.value : '';
            
            if (!dataInicio || !dataFim) {
                showToast('Por favor, selecione as datas de início e fim antes de exportar.', 'error');
                return;
            }
            
            const linhas = document.querySelectorAll('#report-history .history-item');
            if (linhas.length === 0) {
                showToast('Não há dados para exportar.', 'error');
                return;
            }
            
            let csv = 'Descricao;Categoria;Valor;Data;Tipo\n';
            linhas.forEach(linha => {
                const colunas = linha.querySelectorAll('div');
                const descricao = colunas[0] ? colunas[0].textContent : '';
                const categoria = colunas[1] ? colunas[1].textContent : '';
                const valor = colunas[2] ? colunas[2].textContent.replace('R$ ', '') : '';
                const data = colunas[3] ? colunas[3].textContent : '';
                const tipo = colunas[4] ? colunas[4].textContent : '';
                
                csv += '"' + descricao + '";"' + categoria + '";"' + valor + '";"' + data + '";"' + tipo + '"\n';
            });
            
            const totalReceitasEl = document.getElementById('total-receitas');
            const totalDespesasEl = document.getElementById('total-despesas');
            const saldoPeriodoEl = document.getElementById('saldo-periodo');
            
            const totalReceitas = totalReceitasEl ? totalReceitasEl.textContent.replace('R$ ', '') : '0,00';
            const totalDespesas = totalDespesasEl ? totalDespesasEl.textContent.replace('R$ ', '') : '0,00';
            const saldo = saldoPeriodoEl ? saldoPeriodoEl.textContent.replace('R$ ', '') : '0,00';
            
            csv += '\n';
            csv += '"Total de Receitas";"";"' + totalReceitas + '";"";"\n';
            csv += '"Total de Despesas";"";"' + totalDespesas + '";"";"\n';
            csv += '"Saldo do Periodo";"";"' + saldo + '";"";"\n';
            
            const blob = new Blob(['\uFEFF' + csv], { type: 'text/csv;charset=utf-8;' });
            const link = document.createElement('a');
            const url = URL.createObjectURL(blob);
            
            link.setAttribute('href', url);
            link.setAttribute('download', 'relatorio_' + dataInicio + '_' + dataFim + '.csv');
            link.style.visibility = 'hidden';
            
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        });
    }
    
    // ===============================
    // FUNÇÕES AUXILIARES
    // ===============================
    function formatarData(dataStr) {
        if (!dataStr) return '-';
        try {
            const data = new Date(dataStr + 'T00:00:00');
            const dia = String(data.getDate()).padStart(2, '0');
            const mes = String(data.getMonth() + 1).padStart(2, '0');
            const ano = data.getFullYear();
            return dia + '/' + mes + '/' + ano;
        } catch (e) {
            return '-';
        }
    }
    
    // Define datas padrão (mês atual)
    const hoje = new Date();
    const primeiroDia = new Date(hoje.getFullYear(), hoje.getMonth(), 1);
    const ultimoDia = new Date(hoje.getFullYear(), hoje.getMonth() + 1, 0);
    
    const startDateInput = document.getElementById('start-date');
    const endDateInput = document.getElementById('end-date');
    
    if (startDateInput) startDateInput.value = primeiroDia.toISOString().split('T')[0];
    if (endDateInput) endDateInput.value = ultimoDia.toISOString().split('T')[0];
});