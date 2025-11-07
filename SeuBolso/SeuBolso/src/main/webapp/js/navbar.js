// ✅ Prevenir execução duplicada
if (!window.navbarInitialized) {
    window.navbarInitialized = true;

    document.addEventListener("DOMContentLoaded", function () {
        
        // ===============================
        // 💾 GERENCIAMENTO DE NOTIFICAÇÕES DISMISSADAS (EM MEMÓRIA)
        // ===============================
        
        // Armazena notificações dismissadas em memória durante a sessão
        if (!window.notificacoesDismissadas) {
            window.notificacoesDismissadas = [];
        }
        
        // Salva notificação como dismissada
        function dismissarNotificacao(notifId) {
            if (!window.notificacoesDismissadas.includes(notifId)) {
                window.notificacoesDismissadas.push(notifId);
                console.log('Notificação dismissada:', notifId);
            }
        }
        
        // Verifica se notificação foi dismissada
        function foiDismissada(notifId) {
            return window.notificacoesDismissadas.includes(notifId);
        }

        // ===============================
        // ⚙️ BOTÃO DE CONFIGURAÇÃO
        // ===============================
        const btnConfig = document.getElementById("configuracao-btn");
        const popoverConfig = document.getElementById("popover-configuracao");
        const fecharPopover = document.getElementById("fechar-popover-config");

        if (btnConfig && popoverConfig && fecharPopover) {
            btnConfig.onclick = function (e) {
                e.preventDefault();
                const popoverNotificacao = document.getElementById("popover-notificacao");
                if (popoverNotificacao) popoverNotificacao.style.display = "none";
                
                const rect = btnConfig.getBoundingClientRect();
                popoverConfig.style.display = "block";

                let top = rect.bottom + window.scrollY + 8;
                let left = rect.left + window.scrollX;

                const popoverWidth = popoverConfig.offsetWidth || 240;
                const popoverHeight = popoverConfig.offsetHeight || 120;
                const viewportWidth = window.innerWidth;
                const viewportHeight = window.innerHeight;

                if (left + popoverWidth > viewportWidth) {
                    left = viewportWidth - popoverWidth - 16;
                }
                if (top + popoverHeight > viewportHeight) {
                    top = rect.top + window.scrollY - popoverHeight - 8;
                }

                popoverConfig.style.top = top + "px";
                popoverConfig.style.left = left + "px";
            };

            fecharPopover.onclick = function () {
                popoverConfig.style.display = "none";
            };

            document.addEventListener("mousedown", function (e) {
                if (popoverConfig.style.display === "block" && !popoverConfig.contains(e.target) && e.target !== btnConfig && !btnConfig.contains(e.target)) {
                    popoverConfig.style.display = "none";
                }
            });
        }

        // ===============================
        // 🔔 NOTIFICAÇÕES
        // ===============================
        const btnNotificacao = document.getElementById("notificacao-btn");
        const popoverNotificacao = document.getElementById("popover-notificacao");
        const fecharPopoverNotificacao = document.getElementById("fechar-popover-notificacao");
        const notificacaoBadge = document.getElementById("notificacao-badge");

        function criarElementoNotificacao(notif) {
            const li = document.createElement("li");
            li.className = "notificacao-item";
            li.dataset.notifId = notif.id;
            
            // Define cor de fundo baseado no tipo
            let bgColor = '#f8f9fa';
            if (notif.tipo === 'atrasado') bgColor = '#fee';
            else if (notif.tipo === 'hoje') bgColor = '#fff3cd';
            else if (notif.tipo === 'amanha') bgColor = '#e7f3ff';
            
            li.style.cssText = `
                padding: 12px;
                margin-bottom: 8px;
                border-radius: 8px;
                background: ${bgColor};
                border-left: 4px solid ${notif.tipo === 'atrasado' ? '#e74c3c' : notif.tipo === 'hoje' ? '#f39c12' : '#3498db'};
                position: relative;
                cursor: default;
                transition: all 0.3s ease;
            `;
            
            li.innerHTML = `
                <div style="display: flex; justify-content: space-between; align-items: flex-start; gap: 10px;">
                    <div style="flex: 1;">
                        <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 4px;">
                            <span style="font-size: 1.2em;">${notif.icone}</span>
                            <strong style="color: #2c3e50; font-size: 0.95em;">${notif.titulo}</strong>
                        </div>
                        <div style="color: #7f8c8d; font-size: 0.85em; margin-bottom: 4px;">
                            ${notif.mensagem}
                        </div>
                        <div style="color: #e74c3c; font-weight: 600; font-size: 0.9em;">
                            ${notif.valor}
                        </div>
                    </div>
                    <button class="btn-dismiss-notif" data-notif-id="${notif.id}" 
                        style="background: none; border: none; color: #95a5a6; font-size: 1.5em; 
                               cursor: pointer; padding: 0; width: 24px; height: 24px; 
                               line-height: 1; transition: all 0.2s ease; flex-shrink: 0;"
                        title="Remover notificação">
                        ×
                    </button>
                </div>
            `;
            
            // Hover effects
            li.addEventListener('mouseenter', function() {
                this.style.transform = 'translateX(-2px)';
                this.style.boxShadow = '0 2px 8px rgba(0,0,0,0.1)';
            });
            
            li.addEventListener('mouseleave', function() {
                this.style.transform = 'translateX(0)';
                this.style.boxShadow = 'none';
            });
            
            // Botão de dismiss
            const btnDismiss = li.querySelector('.btn-dismiss-notif');
            btnDismiss.addEventListener('mouseenter', function() {
                this.style.color = '#e74c3c';
                this.style.transform = 'scale(1.2)';
            });
            
            btnDismiss.addEventListener('mouseleave', function() {
                this.style.color = '#95a5a6';
                this.style.transform = 'scale(1)';
            });
            
            btnDismiss.addEventListener('click', function(e) {
                e.stopPropagation();
                const notifId = this.dataset.notifId;
                
                // Animação de saída
                li.style.opacity = '0';
                li.style.transform = 'translateX(30px)';
                
                setTimeout(() => {
                    dismissarNotificacao(notifId);
                    li.remove();
                    
                    // Atualiza badge
                    const lista = document.getElementById("notificacao-lista");
                    const notificacoesRestantes = lista.querySelectorAll('.notificacao-item').length;
                    
                    if (notificacoesRestantes === 0) {
                        lista.innerHTML = '<li style="padding:12px; color:#999; text-align: center;">Nenhuma notificação no momento 🎉</li>';
                        if (notificacaoBadge) {
                            notificacaoBadge.style.display = "none";
                        }
                    } else {
                        if (notificacaoBadge) {
                            notificacaoBadge.textContent = notificacoesRestantes;
                        }
                    }
                }, 300);
            });
            
            return li;
        }

        function carregarNotificacoes() {
            const lista = document.getElementById("notificacao-lista");
            if (!lista) {
                console.error('Elemento notificacao-lista não encontrado!');
                return;
            }
            
            console.log('Carregando notificações...');
            
            fetch("NotificacaoServlet")
                .then(response => {
                    console.log('Response status:', response.status);
                    if (!response.ok) {
                        throw new Error('Erro HTTP: ' + response.status);
                    }
                    return response.json();
                })
                .then(data => {
                    console.log('Dados recebidos:', data);
                    
                    if (data.notificacoes && data.notificacoes.length > 0) {
                        // Filtra notificações que não foram dismissadas
                        const notificacoesVisiveis = data.notificacoes.filter(notif => !foiDismissada(notif.id));
                        
                        console.log('Notificações visíveis:', notificacoesVisiveis.length);
                        
                        if (notificacoesVisiveis.length > 0) {
                            lista.innerHTML = "";
                            
                            // Ordena por prioridade (menor número = maior prioridade)
                            notificacoesVisiveis.sort((a, b) => a.prioridade - b.prioridade);
                            
                            notificacoesVisiveis.forEach(notif => {
                                lista.appendChild(criarElementoNotificacao(notif));
                            });
                            
                            if (notificacaoBadge) {
                                notificacaoBadge.textContent = notificacoesVisiveis.length;
                                notificacaoBadge.style.display = "block";
                            }
                        } else {
                            lista.innerHTML = '<li style="padding:12px; color:#999; text-align: center;">Nenhuma notificação no momento 🎉</li>';
                            if (notificacaoBadge) {
                                notificacaoBadge.style.display = "none";
                            }
                        }
                    } else {
                        console.log('Nenhuma notificação encontrada');
                        lista.innerHTML = '<li style="padding:12px; color:#999; text-align: center;">Nenhuma notificação no momento 🎉</li>';
                        if (notificacaoBadge) {
                            notificacaoBadge.style.display = "none";
                        }
                    }
                })
                .catch(error => {
                    console.error('Erro ao carregar notificações:', error);
                    lista.innerHTML = '<li style="padding:12px; color:#e74c3c; text-align: center;">⚠️ Erro ao carregar notificações</li>';
                    if (notificacaoBadge) {
                        notificacaoBadge.style.display = "none";
                    }
                });
        }

        // Carrega notificações ao iniciar
        console.log('Iniciando carregamento de notificações...');
        carregarNotificacoes();

        if (btnNotificacao && popoverNotificacao && fecharPopoverNotificacao) {
            btnNotificacao.onclick = function (e) {
                e.preventDefault();
                console.log('Botão de notificação clicado');
                
                if (popoverConfig) popoverConfig.style.display = "none";
                
                carregarNotificacoes();
                
                const rect = btnNotificacao.getBoundingClientRect();
                popoverNotificacao.style.display = "block";

                let top = rect.bottom + window.scrollY + 8;
                let left = rect.left + window.scrollX;

                const popoverWidth = popoverNotificacao.offsetWidth || 350;
                const popoverHeight = popoverNotificacao.offsetHeight || 150;
                const viewportWidth = window.innerWidth;
                const viewportHeight = window.innerHeight;

                if (left + popoverWidth > viewportWidth) {
                    left = viewportWidth - popoverWidth - 16;
                }
                if (top + popoverHeight > viewportHeight) {
                    top = rect.top + window.scrollY - popoverHeight - 8;
                }

                popoverNotificacao.style.top = top + "px";
                popoverNotificacao.style.left = left + "px";
            };

            fecharPopoverNotificacao.onclick = function () {
                popoverNotificacao.style.display = "none";
            };

            document.addEventListener("mousedown", function (e) {
                if (popoverNotificacao.style.display === "block" && !popoverNotificacao.contains(e.target) && e.target !== btnNotificacao && !btnNotificacao.contains(e.target)) {
                    popoverNotificacao.style.display = "none";
                }
            });
        } else {
            console.error('Elementos de notificação não encontrados:', {
                btnNotificacao: !!btnNotificacao,
                popoverNotificacao: !!popoverNotificacao,
                fecharPopoverNotificacao: !!fecharPopoverNotificacao
            });
        }

        // ===============================
        // 🚪 LOGOUT
        // ===============================
        function handleLogout(e) {
            e.preventDefault();
            
            if (window.logoutInProgress) return;
            window.logoutInProgress = true;
            
            if (popoverConfig) popoverConfig.style.display = "none";
            if (popoverNotificacao) popoverNotificacao.style.display = "none";
            
            fetch("LogoutServlet")
                .then(() => {
                    window.location.href = "index.jsp";
                })
                .catch(() => {
                    window.location.href = "index.jsp";
                });
        }

        const logoutLink = document.getElementById("logout-link");
        const menuLogout = document.getElementById("menu-logout");
        
        if (logoutLink && !logoutLink.dataset.logoutBound) {
            logoutLink.dataset.logoutBound = "true";
            logoutLink.addEventListener("click", handleLogout);
        }
        if (menuLogout && !menuLogout.dataset.logoutBound) {
            menuLogout.dataset.logoutBound = "true";
            menuLogout.addEventListener("click", handleLogout);
        }

        // ===============================
        // 🍔 MENU HAMBURGUER
        // ===============================
        const hamburguerBtn = document.getElementById("hamburguer-btn");
        const menuLateral = document.getElementById("menu-lateral");
        const fecharMenu = document.getElementById("fechar-menu");
        const overlay = document.getElementById("overlay");

        if (hamburguerBtn && menuLateral) {
            hamburguerBtn.onclick = function() {
                menuLateral.classList.add("ativo");
                if (overlay) overlay.classList.add("ativo");
            };
        }

        if (fecharMenu && menuLateral) {
            fecharMenu.onclick = function() {
                menuLateral.classList.remove("ativo");
                if (overlay) overlay.classList.remove("ativo");
            };
        }

        if (overlay && menuLateral) {
            overlay.onclick = function() {
                menuLateral.classList.remove("ativo");
                overlay.classList.remove("ativo");
            };
        }
        
        // ===============================
        // 🔄 ATUALIZA NOTIFICAÇÕES PERIODICAMENTE
        // ===============================
        setInterval(function() {
            // Atualiza badge a cada 2 minutos (mas só se o popover estiver fechado)
            if (popoverNotificacao && popoverNotificacao.style.display !== "block") {
                fetch("NotificacaoServlet")
                    .then(response => response.json())
                    .then(data => {
                        if (notificacaoBadge && data.notificacoes) {
                            const notificacoesVisiveis = data.notificacoes.filter(notif => !foiDismissada(notif.id));
                            
                            if (notificacoesVisiveis.length > 0) {
                                notificacaoBadge.textContent = notificacoesVisiveis.length;
                                notificacaoBadge.style.display = "block";
                            } else {
                                notificacaoBadge.style.display = "none";
                            }
                        }
                    })
                    .catch(error => {
                        console.error('Erro ao atualizar badge:', error);
                    });
            }
        }, 120000); // 2 minutos
    });
}