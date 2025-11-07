document.addEventListener("DOMContentLoaded", function () {

    // ========== CORES CENTRALIZADAS ==========
    // O objeto CORES é importado do JSP.
    
    // ===============================
    // 📅 INICIALIZAÇÃO DO CALENDÁRIO
    // ===============================
    const calendarEl = document.getElementById("calendar");
    if (!calendarEl) return;

    // Função para gerar eventos recorrentes de despesas fixas
    function gerarEventosRecorrentes(lancamentos) {
        const eventosGerados = [];
        const dataAtual = new Date();
        const anoAtual = dataAtual.getFullYear();
        const mesAtual = dataAtual.getMonth();

        lancamentos.forEach(l => {
            
            // 🚀 Normaliza o tipo vindo do JSP (despesa ou receita)
            const tipoNormalizado = (l.tipo || 'receita').toString().trim().toLowerCase();
            const tipoFinal = tipoNormalizado === 'despesa' ? 'despesa' : 'receita';
            
            // Pega as cores
            const cores = CORES[tipoFinal];
            
            // Log para debug CRUCIAL
            console.log(`[GERAR] Lançamento: ${l.title} | Tipo: ${tipoFinal} | Cor de fundo: ${cores.background}`);
            
            // Verifica se é despesa fixa
            if (l.fixo === true && tipoFinal === "despesa") {
                const diaVencimento = parseInt(l.diaVencimento);

                for (let i = -3; i <= 12; i++) {
                    const novaData = new Date(anoAtual, mesAtual + i, diaVencimento);
                    
                    if (novaData.getDate() !== diaVencimento) {
                        novaData.setDate(0);
                    }

                    const dataFormatada = novaData.toISOString().split('T')[0];
                    
                    eventosGerados.push({
                        title: l.title + " (Fixo)",
                        start: dataFormatada,
                        
                        // 💡 PASSA AS CORES DIRETAMENTE
                        backgroundColor: cores.background,
                        borderColor: cores.border,
                        textColor: cores.text,
                        
                        extendedProps: {
                            tipo: tipoFinal,
                            fixo: true,
                            diaVencimento: diaVencimento
                        }
                    });
                }
            } else {
                // Para lançamentos não fixos (receitas ou despesas variáveis)
                eventosGerados.push({
                    title: l.title,
                    start: l.start,
                    
                    // 💡 PASSA AS CORES DIRETAMENTE
                    backgroundColor: cores.background,
                    borderColor: cores.border,
                    textColor: cores.text,
                    
                    extendedProps: {
                        tipo: tipoFinal,
                        fixo: false
                    }
                });
            }
        });

        return eventosGerados;
    }

    const eventosCalendario = gerarEventosRecorrentes(lancamentos);
    console.log("Eventos gerados para o calendário:", eventosCalendario);

    const calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: "dayGridMonth",
        locale: "pt-br",
        firstDay: 1,
        headerToolbar: {
            left: "prev,next today",
            center: "title",
            right: "dayGridMonth,timeGridWeek,timeGridDay"
        },
        buttonText: {
            today: "Hoje",
            month: "Mês",
            week: "Semana",
            day: "Dia"
        },
        allDayText: "Dia todo",
        events: eventosCalendario,
        
        // 🛡️ CAMADA DE SEGURANÇA 2.0: Força o estilo com !important
        eventDidMount: function(info) {
            const tipo = (info.event.extendedProps.tipo || 'receita').toString().trim().toLowerCase();
            const tipoFinal = tipo === 'despesa' ? 'despesa' : 'receita';
            const cores = CORES[tipoFinal];
            
            // Log para debug
            console.log(`[MOUNT] Renderizando: ${info.event.title} | Cor aplicada: ${cores.background}`);

            // 1. Força background e border no elemento principal (.fc-event)
            info.el.style.setProperty('background-color', cores.background, 'important');
            info.el.style.setProperty('border-color', cores.border, 'important');
            
            // 2. Tenta forçar o background em elementos internos que podem estar sobrepondo o fundo principal
            const elementsToForceBg = info.el.querySelectorAll('.fc-event-main, .fc-event-main-frame, a');
            elementsToForceBg.forEach(el => {
                el.style.setProperty('background-color', cores.background, 'important');
            });

            // 3. Garante que o texto seja branco (ou a cor definida)
            const textElements = info.el.querySelectorAll('.fc-event-title, .fc-event-time, *');
            textElements.forEach(el => {
                el.style.setProperty('color', cores.text, 'important');
            });
            
            // Adiciona estilo para despesas fixas
            if (info.event.extendedProps.fixo) {
                info.el.style.fontWeight = "bold";
                info.el.title = "Despesa Fixa Recorrente";
            }
        }
    });

    calendar.render();

    // ===============================
    // 🏷️ LEGENDA DINÂMICA
    // ===============================
    function atualizarLegenda() {
        const legendaContainer = document.createElement("div");
        legendaContainer.className = "legenda-calendario";
        legendaContainer.style.marginTop = "20px";
        legendaContainer.style.textAlign = "center";
        legendaContainer.style.padding = "15px";
        legendaContainer.style.backgroundColor = "#fff";
        legendaContainer.style.borderRadius = "8px";
        legendaContainer.style.boxShadow = "0 2px 4px rgba(0,0,0,0.1)";

        const tipos = {
            "Despesa": CORES.despesa.background,
            "Receita": CORES.receita.background
        };

        Object.keys(tipos).forEach(tipo => {
            const item = document.createElement("span");
            item.className = "legenda-item";
            item.style.display = "inline-block";
            item.style.marginRight = "20px";
            item.style.fontSize = "14px";

            const cor = document.createElement("span");
            cor.style.display = "inline-block";
            cor.style.width = "20px";
            cor.style.height = "20px";
            cor.style.backgroundColor = tipos[tipo];
            cor.style.marginRight = "8px";
            cor.style.borderRadius = "3px";
            cor.style.verticalAlign = "middle";

            item.appendChild(cor);
            item.appendChild(document.createTextNode(tipo));
            legendaContainer.appendChild(item);
        });

        const conteudo = document.querySelector(".conteudo");
        if (conteudo && !document.querySelector(".legenda-calendario")) {
             conteudo.appendChild(legendaContainer);
        }
    }

    atualizarLegenda();

});