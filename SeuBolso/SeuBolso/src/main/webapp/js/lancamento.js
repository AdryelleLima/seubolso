document.addEventListener("DOMContentLoaded", function () {
    var contextPath = "/SeuBolso";
    var endpoint = `${contextPath}/lancamentos`;

    var formAdd = document.getElementById("form-lancamento");
    var formEdit = document.getElementById("form-editar");
    var modalEl = document.getElementById("modal-editar");
    var toastHostId = "toastContainer";
    var fallbackToastId = "toast";
    var toastHost = document.getElementById(toastHostId) || document.getElementById(fallbackToastId);

    if (!toastHost) {
        toastHost = document.createElement("div");
        toastHost.id = toastHostId;
        toastHost.className = "toast-container position-fixed bottom-0 end-0 p-3";
        toastHost.style.zIndex = "2000";
        document.body.appendChild(toastHost);
    }

    var bsModal = null;
    if (modalEl && typeof bootstrap !== "undefined") {
        bsModal = new bootstrap.Modal(modalEl, { backdrop: "static" });
    }

    // Modal de confirmação de exclusão
    var modalExclusaoEl = document.getElementById("modal-confirmar-exclusao");
    var bsModalExclusao = null;
    if (modalExclusaoEl && typeof bootstrap !== "undefined") {
        bsModalExclusao = new bootstrap.Modal(modalExclusaoEl);
    }

    var lancamentoParaExcluir = { id: null, titulo: "" };

    // ---------- ALTERNAR TIPO (RECEITA/DESPESA) ----------
    var radioReceita = document.getElementById("receita");
    var radioDespesa = document.getElementById("despesa");
    var tipoHidden = document.getElementById("tipo-hidden");
    var btnAdd = document.getElementById("btn-add");
    var campoVencimento = document.getElementById("campo-vencimento");
    var campoFixa = document.getElementById("campo-fixa");

    function atualizarCamposPorTipo() {
        var isDespesa = radioDespesa && radioDespesa.checked;
        
        // Atualiza hidden field
        if (tipoHidden) {
            tipoHidden.value = isDespesa ? "despesa" : "receita";
        }
        
        // Atualiza texto do botão
        if (btnAdd) {
            var icon = '<i class="fas fa-plus"></i> ';
            btnAdd.innerHTML = isDespesa ? icon + "Adicionar Despesa" : icon + "Adicionar Receita";
        }
        
        // Mostra/oculta campos específicos de despesa
        if (campoVencimento) {
            campoVencimento.style.display = isDespesa ? "block" : "none";
        }
        if (campoFixa) {
            campoFixa.style.display = isDespesa ? "block" : "none";
        }
    }

    if (radioReceita) {
        radioReceita.addEventListener("change", atualizarCamposPorTipo);
    }
    if (radioDespesa) {
        radioDespesa.addEventListener("change", atualizarCamposPorTipo);
    }

    // Inicializa os campos na carga da página
    atualizarCamposPorTipo();

    // ---------- FUNÇÃO DE TOAST ----------
    function showToast(message, type) {
        type = type || "success";
        var bg = (type === "success") ? "bg-success text-white" : "bg-danger text-white";
        var wrapper = document.createElement("div");
        wrapper.className = "toast align-items-center " + bg + " border-0 show";
        wrapper.role = "alert";
        wrapper.style.minWidth = "220px";
        wrapper.innerHTML =
            '<div class="d-flex">' +
            '<div class="toast-body">' + message + '</div>' +
            '<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>' +
            '</div>';
        toastHost.appendChild(wrapper);

        if (typeof bootstrap !== "undefined" && bootstrap.Toast) {
            var t = new bootstrap.Toast(wrapper, { delay: 3500 });
            t.show();
            wrapper.addEventListener("hidden.bs.toast", function () { wrapper.remove(); });
        } else {
            setTimeout(function () { wrapper.remove(); }, 3500);
        }
    }

    // ---------- FUNÇÕES AUXILIARES ----------
    function getTipoFromRadios() {
        var rReceita = document.getElementById("receita");
        if (rReceita && rReceita.checked) return "RECEITA";
        var rDespesa = document.getElementById("despesa");
        if (rDespesa && rDespesa.checked) return "DESPESA";
        var hiddenTipo = document.getElementById("tipo-hidden");
        return hiddenTipo ? (hiddenTipo.value || "RECEITA").toUpperCase() : "RECEITA";
    }

    function enforceValueSign(valorEl, tipo) {
        if (!valorEl) return;
        if (tipo === "DESPESA") {
            if (valorEl.value && Number(valorEl.value) > 0)
                valorEl.value = -Math.abs(valorEl.value);
        } else {
            if (valorEl.value && Number(valorEl.value) < 0)
                valorEl.value = Math.abs(valorEl.value);
        }
    }

    // ---------- ABRIR MODAL EDITAR ----------
    window.abrirModalEditar = function (id) {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", endpoint + "?action=buscar&id=" + encodeURIComponent(id), true);
        xhr.setRequestHeader("Accept", "application/json");

        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    try {
                        var lanc = JSON.parse(xhr.responseText);
                        var f = {
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

                        // Mostra/oculta campo de vencimento no modal baseado no tipo
                        var editCampoVencimento = document.getElementById("edit-campo-vencimento");
                        if (editCampoVencimento) {
                            editCampoVencimento.style.display = 
                                (lanc.tipo && lanc.tipo.toUpperCase() === "DESPESA") ? "block" : "none";
                        }

                        if (bsModal) bsModal.show();
                        else if (modalEl) {
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

    // ---------- EXCLUIR LANCAMENTO ----------
    window.excluirLancamento = function (id, titulo) {
        lancamentoParaExcluir.id = id;
        lancamentoParaExcluir.titulo = titulo;

        var tituloEl = document.getElementById("delete-lancamento-titulo");
        if (tituloEl) {
            tituloEl.textContent = '"' + titulo + '"';
        }

        if (bsModalExclusao) {
            bsModalExclusao.show();
        }
    };

    // Botão de confirmar exclusão no modal
    var btnConfirmarExclusao = document.getElementById("btn-confirmar-exclusao");
    if (btnConfirmarExclusao) {
        btnConfirmarExclusao.addEventListener("click", function () {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", endpoint, true);
            xhr.setRequestHeader("Content-Type", "application/json");
            xhr.setRequestHeader("Accept", "application/json");

            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    var json;
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

    // ---------- SALVAR NOVO LANCAMENTO ----------
    if (formAdd) {
        formAdd.addEventListener("submit", function (e) {
            e.preventDefault();
            var usuarioIdEl = document.getElementById("usuarioId");
            var usuarioId = usuarioIdEl ? Number(usuarioIdEl.value) : null;

            var tipo = getTipoFromRadios().toUpperCase();
            var valorEl = document.getElementById("valor");
            enforceValueSign(valorEl, tipo);

            var payload = {
                action: "salvar",
                titulo: document.getElementById("titulo").value,
                valor: Number(valorEl.value),
                categoria: document.getElementById("categoria").value,
                data: document.getElementById("data").value,
                formaPagamento: document.getElementById("formaPagamento").value,
                descricao: document.getElementById("descricao").value,
                tipo: tipo,
                vencimento: document.getElementById("vencimento").value || "",
                despesaFixa: !!document.getElementById("fixa") && document.getElementById("fixa").checked,
                usuarioId: usuarioId
            };

            var xhr = new XMLHttpRequest();
            xhr.open("POST", endpoint, true);
            xhr.setRequestHeader("Content-Type", "application/json");
            xhr.setRequestHeader("Accept", "application/json");

            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    var json;
                    try { json = JSON.parse(xhr.responseText); } catch (e) { json = null; }
                    if (xhr.status === 200 && json && json.status === "sucesso") {
                        showToast(json.mensagem || "Lançamento salvo com sucesso!", "success");
                        setTimeout(function () { window.location.reload(); }, 700);
                    } else {
                        showToast((json && json.mensagem) || "Erro ao salvar.", "error");
                    }
                }
            };
            xhr.send(JSON.stringify(payload));
        });
    }

    // ---------- EDITAR LANCAMENTO ----------
    if (formEdit) {
        formEdit.addEventListener("submit", function (e) {
            e.preventDefault();

            var usuarioIdEl = document.getElementById("usuarioId");
            var usuarioId = usuarioIdEl ? Number(usuarioIdEl.value) : null;

            var tipo = (document.getElementById("edit-tipo").value || "RECEITA").toUpperCase();
            var valorEl = document.getElementById("edit-valor");
            
            var valorNumerico = Math.abs(Number(valorEl.value));
            if (tipo === "DESPESA") {
                valorNumerico = -valorNumerico;
            }

            var payload = {
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

            var xhr = new XMLHttpRequest();
            xhr.open("POST", endpoint, true);
            xhr.setRequestHeader("Content-Type", "application/json");
            xhr.setRequestHeader("Accept", "application/json");

            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    var json;
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

});