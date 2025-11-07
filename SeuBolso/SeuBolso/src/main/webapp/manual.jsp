<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.Usuario"%>
<%
// Verifica se o usuário está logado
Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
if (usuarioLogado == null) {
    response.sendRedirect("login.jsp");
    return;
}
%>
<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Manual do Usuário - SeuBolso</title>

    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet" />

    <!-- CSS -->
    <link href="css/main.css" rel="stylesheet" />
    <link href="css/manual.css" rel="stylesheet" />
</head>

<body>
    <jsp:include page="navbar.jsp" />

    <main class="manual-container">
        <!-- ==================== HEADER ==================== -->
        <header class="manual-header">
            <div class="header-icon">
                <i class="fas fa-book-open"></i>
            </div>
            <h1>Manual do Usuário</h1>
            <p class="subtitle">Guia completo para dominar o SeuBolso e ter controle total das suas finanças</p>
        </header>

        <!-- ==================== ÍNDICE RÁPIDO ==================== -->
        <nav class="quick-nav">
            <h3><i class="fas fa-list me-2"></i>Navegação Rápida</h3>
            <div class="nav-links">
                <a href="#intro"><i class="fas fa-home"></i> Introdução</a>
                <a href="#visao-geral"><i class="fas fa-chart-line"></i> Visão Geral</a>
                <a href="#calendario"><i class="fas fa-calendar-alt"></i> Calendário</a>
                <a href="#lancamentos"><i class="fas fa-file-invoice-dollar"></i> Lançamentos</a>
                <a href="#lista-desejos"><i class="fas fa-heart"></i> Lista de Desejos</a>
                <a href="#relatorios"><i class="fas fa-chart-pie"></i> Relatórios</a>
                <a href="#perfil"><i class="fas fa-user-circle"></i> Perfil</a>
                <a href="#notificacoes"><i class="fas fa-bell"></i> Notificações</a>
                <a href="#dicas"><i class="fas fa-lightbulb"></i> Dicas</a>
            </div>
        </nav>

        <!-- ==================== INTRODUÇÃO ==================== -->
        <section id="intro" class="section">
            <h2 class="section-title">
                <i class="fas fa-home me-2"></i>Bem-vindo ao SeuBolso
            </h2>
            <div class="intro-content">
                <p class="intro-text">
                    O <strong>SeuBolso</strong> é sua ferramenta completa de controle financeiro pessoal. 
                    Desenvolvido para ajudá-lo a organizar receitas, despesas, definir metas e acompanhar 
                    sua saúde financeira de forma simples e eficiente.
                </p>
                <div class="feature-grid">
                    <div class="feature-highlight">
                        <i class="fas fa-check-circle"></i>
                        <span>Controle total de receitas e despesas</span>
                    </div>
                    <div class="feature-highlight">
                        <i class="fas fa-check-circle"></i>
                        <span>Calendário financeiro interativo</span>
                    </div>
                    <div class="feature-highlight">
                        <i class="fas fa-check-circle"></i>
                        <span>Relatórios e gráficos detalhados</span>
                    </div>
                    <div class="feature-highlight">
                        <i class="fas fa-check-circle"></i>
                        <span>Lista de desejos e metas</span>
                    </div>
                </div>
            </div>
        </section>

        <!-- ==================== VISÃO GERAL ==================== -->
        <section id="visao-geral" class="section">
            <h2 class="section-title">
                <i class="fas fa-chart-line me-2"></i>Visão Geral (Dashboard)
            </h2>
            
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-info-circle"></i>
                    <h3>O que é?</h3>
                </div>
                <div class="card-content">
                    <p>A página inicial do sistema que apresenta um resumo completo da sua situação financeira atual.</p>
                </div>
            </div>

            <div class="card-list">
                <div class="card">
                    <div class="card-icon receitas">
                        <i class="fas fa-wallet"></i>
                    </div>
                    <div class="card-content">
                        <h3>Resumo Financeiro</h3>
                        <ul>
                            <li><strong>Total de Receitas:</strong> Soma de todas as receitas registradas</li>
                            <li><strong>Total de Despesas:</strong> Soma de todas as despesas registradas</li>
                            <li><strong>Saldo Geral:</strong> Diferença entre receitas e despesas</li>
                        </ul>
                    </div>
                </div>

                <div class="card">
                    <div class="card-icon chart">
                        <i class="fas fa-chart-pie"></i>
                    </div>
                    <div class="card-content">
                        <h3>Gráfico de Distribuição</h3>
                        <p>Visualização em gráfico de pizza mostrando a proporção entre receitas e despesas.</p>
                    </div>
                </div>

                <div class="card">
                    <div class="card-icon historico">
                        <i class="fas fa-history"></i>
                    </div>
                    <div class="card-content">
                        <h3>Histórico de Lançamentos</h3>
                        <p>Listagem dos 10 últimos lançamentos registrados, com opção de ver todos.</p>
                    </div>
                </div>

                <div class="card">
                    <div class="card-icon acoes">
                        <i class="fas fa-bolt"></i>
                    </div>
                    <div class="card-content">
                        <h3>Ações Rápidas</h3>
                        <p>Atalhos para as principais funcionalidades: adicionar lançamento, lista de desejos e perfil.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- ==================== CALENDÁRIO ==================== -->
        <section id="calendario" class="section">
            <h2 class="section-title">
                <i class="fas fa-calendar-alt me-2"></i>Calendário Financeiro
            </h2>
            
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-info-circle"></i>
                    <h3>Como funciona?</h3>
                </div>
                <div class="card-content">
                    <p>O calendário exibe todos os seus lançamentos financeiros de forma visual e organizada por data.</p>
                </div>
            </div>

            <div class="tutorial-steps">
                <div class="step">
                    <div class="step-number">1</div>
                    <div class="step-content">
                        <h4>Visualização</h4>
                        <p>Escolha entre visualização mensal, semanal ou diária usando os botões no topo.</p>
                    </div>
                </div>

                <div class="step">
                    <div class="step-number">2</div>
                    <div class="step-content">
                        <h4>Navegação</h4>
                        <p>Use as setas para navegar entre meses ou clique em "Hoje" para voltar ao dia atual.</p>
                    </div>
                </div>

                <div class="step">
                    <div class="step-number">3</div>
                    <div class="step-content">
                        <h4>Cores</h4>
                        <p><span class="badge receita">Verde</span> para receitas e <span class="badge despesa">Vermelho</span> para despesas.</p>
                    </div>
                </div>

                <div class="step">
                    <div class="step-number">4</div>
                    <div class="step-content">
                        <h4>Despesas Fixas</h4>
                        <p>Despesas fixas aparecem em <strong>negrito</strong> e se repetem automaticamente nos próximos meses.</p>
                    </div>
                </div>
            </div>

            <div class="tip-box">
                <i class="fas fa-lightbulb"></i>
                <div>
                    <strong>Dica:</strong>
                    <p>As despesas fixas são ideais para contas recorrentes como aluguel, internet, luz, água, etc.</p>
                </div>
            </div>
        </section>

        <!-- ==================== LANÇAMENTOS ==================== -->
        <section id="lancamentos" class="section">
            <h2 class="section-title">
                <i class="fas fa-file-invoice-dollar me-2"></i>Gerenciar Lançamentos
            </h2>
            
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-info-circle"></i>
                    <h3>O que são lançamentos?</h3>
                </div>
                <div class="card-content">
                    <p>Lançamentos são registros de todas as movimentações financeiras (receitas e despesas).</p>
                </div>
            </div>

            <h3 class="subsection-title">Como adicionar um lançamento</h3>
            
            <div class="tutorial-steps">
                <div class="step">
                    <div class="step-number">1</div>
                    <div class="step-content">
                        <h4>Acesse a página de Lançamentos</h4>
                        <p>Clique em "Lançamento" no menu ou use o botão "Novo Lançamento" na página inicial.</p>
                    </div>
                </div>

                <div class="step">
                    <div class="step-number">2</div>
                    <div class="step-content">
                        <h4>Preencha o formulário</h4>
                        <ul>
                            <li><strong>Título:</strong> Nome descritivo do lançamento</li>
                            <li><strong>Valor:</strong> Quantia em reais (R$)</li>
                            <li><strong>Tipo:</strong> Receita ou Despesa</li>
                            <li><strong>Categoria:</strong> Classificação do lançamento</li>
                            <li><strong>Data:</strong> Quando ocorreu a movimentação</li>
                            <li><strong>Forma de Pagamento:</strong> Como foi pago/recebido</li>
                            <li><strong>Descrição:</strong> Informações adicionais (opcional)</li>
                        </ul>
                    </div>
                </div>

                <div class="step">
                    <div class="step-number">3</div>
                    <div class="step-content">
                        <h4>Despesas Fixas (opcional)</h4>
                        <p>Marque "Despesa Fixa" e defina o dia do vencimento para despesas recorrentes mensais.</p>
                    </div>
                </div>

                <div class="step">
                    <div class="step-number">4</div>
                    <div class="step-content">
                        <h4>Salvar</h4>
                        <p>Clique no botão "Salvar Lançamento" para registrar.</p>
                    </div>
                </div>
            </div>

            <h3 class="subsection-title">Categorias disponíveis</h3>
            
            <div class="categoria-grid">
                <div class="categoria-item receitas">
                    <h4><i class="fas fa-arrow-up"></i> Receitas</h4>
                    <ul>
                        <li>Salário</li>
                        <li>Freelance</li>
                        <li>Investimentos</li>
                        <li>Vendas</li>
                        <li>Outros</li>
                    </ul>
                </div>
                
                <div class="categoria-item despesas">
                    <h4><i class="fas fa-arrow-down"></i> Despesas</h4>
                    <ul>
                        <li>Alimentação</li>
                        <li>Transporte</li>
                        <li>Moradia</li>
                        <li>Saúde</li>
                        <li>Educação</li>
                        <li>Lazer</li>
                        <li>Outros</li>
                    </ul>
                </div>
            </div>

            <h3 class="subsection-title">Editar e Excluir</h3>
            
            <div class="info-box">
                <i class="fas fa-edit"></i>
                <div>
                    <strong>Editar:</strong>
                    <p>Clique no botão <i class="fas fa-edit"></i> ao lado do lançamento para modificar informações.</p>
                </div>
            </div>

            <div class="info-box warning">
                <i class="fas fa-trash-alt"></i>
                <div>
                    <strong>Excluir:</strong>
                    <p>Clique no botão <i class="fas fa-trash-alt"></i> para remover. <strong>Atenção:</strong> Esta ação não pode ser desfeita!</p>
                </div>
            </div>
        </section>

        <!-- ==================== LISTA DE DESEJOS ==================== -->
        <section id="lista-desejos" class="section">
            <h2 class="section-title">
                <i class="fas fa-heart me-2"></i>Lista de Desejos
            </h2>
            
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-info-circle"></i>
                    <h3>Para que serve?</h3>
                </div>
                <div class="card-content">
                    <p>Registre seus objetivos financeiros, sonhos e metas. Acompanhe o progresso de cada item e quanto você já economizou para realizá-los.</p>
                </div>
            </div>

            <h3 class="subsection-title">Como usar</h3>
            
            <div class="tutorial-steps">
                <div class="step">
                    <div class="step-number">1</div>
                    <div class="step-content">
                        <h4>Adicionar um desejo</h4>
                        <p>Clique em "Adicionar Desejo" e preencha:</p>
                        <ul>
                            <li><strong>Nome:</strong> O que você deseja</li>
                            <li><strong>Valor Total:</strong> Quanto custa</li>
                            <li><strong>Valor Economizado:</strong> Quanto já possui</li>
                            <li><strong>Descrição:</strong> Detalhes sobre o desejo</li>
                            <li><strong>Prioridade:</strong> Alta, Média ou Baixa</li>
                        </ul>
                    </div>
                </div>

                <div class="step">
                    <div class="step-number">2</div>
                    <div class="step-content">
                        <h4>Acompanhar progresso</h4>
                        <p>Uma barra de progresso mostrará visualmente quanto falta para alcançar seu objetivo.</p>
                    </div>
                </div>

                <div class="step">
                    <div class="step-number">3</div>
                    <div class="step-content">
                        <h4>Atualizar valores</h4>
                        <p>Conforme economiza, edite o "Valor Economizado" para ver seu progresso aumentar.</p>
                    </div>
                </div>

                <div class="step">
                    <div class="step-number">4</div>
                    <div class="step-content">
                        <h4>Conquistar!</h4>
                        <p>Quando atingir 100%, você pode marcar como concluído ou excluir o item.</p>
                    </div>
                </div>
            </div>

            <div class="tip-box">
                <i class="fas fa-lightbulb"></i>
                <div>
                    <strong>Dica de uso:</strong>
                    <p>Defina metas realistas e divida grandes objetivos em etapas menores para manter a motivação!</p>
                </div>
            </div>
        </section>

        <!-- ==================== RELATÓRIOS ==================== -->
        <section id="relatorios" class="section">
            <h2 class="section-title">
                <i class="fas fa-chart-pie me-2"></i>Relatórios e Análises
            </h2>
            
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-info-circle"></i>
                    <h3>Visualize suas finanças</h3>
                </div>
                <div class="card-content">
                    <p>Os relatórios transformam seus dados em gráficos e análises para melhor compreensão da sua situação financeira.</p>
                </div>
            </div>

            <div class="card-list">
                <div class="card">
                    <div class="card-icon chart">
                        <i class="fas fa-chart-bar"></i>
                    </div>
                    <div class="card-content">
                        <h3>Gráfico de Evolução</h3>
                        <p>Acompanhe a evolução de receitas e despesas ao longo dos meses em um gráfico de barras.</p>
                    </div>
                </div>

                <div class="card">
                    <div class="card-icon chart">
                        <i class="fas fa-chart-line"></i>
                    </div>
                    <div class="card-content">
                        <h3>Comparação Mensal</h3>
                        <p>Compare seus gastos mês a mês para identificar padrões e tendências.</p>
                    </div>
                </div>

                <div class="card">
                    <div class="card-icon categorias">
                        <i class="fas fa-tags"></i>
                    </div>
                    <div class="card-content">
                        <h3>Despesas por Categoria</h3>
                        <p>Veja para onde seu dinheiro está indo com gráficos divididos por categoria.</p>
                    </div>
                </div>

                <div class="card">
                    <div class="card-icon filtro">
                        <i class="fas fa-filter"></i>
                    </div>
                    <div class="card-content">
                        <h3>Filtros Personalizados</h3>
                        <p>Filtre relatórios por período, categoria ou tipo de lançamento.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- ==================== PERFIL ==================== -->
        <section id="perfil" class="section">
            <h2 class="section-title">
                <i class="fas fa-user-circle me-2"></i>Meu Perfil
            </h2>
            
            <div class="card-list">
                <div class="card">
                    <div class="card-icon perfil">
                        <i class="fas fa-user-edit"></i>
                    </div>
                    <div class="card-content">
                        <h3>Dados Pessoais</h3>
                        <p>Visualize e edite suas informações pessoais:</p>
                        <ul>
                            <li>Nome completo</li>
                            <li>Email</li>
                            <li>Telefone</li>
                            <li>Foto de perfil</li>
                        </ul>
                    </div>
                </div>

                <div class="card">
                    <div class="card-icon seguranca">
                        <i class="fas fa-lock"></i>
                    </div>
                    <div class="card-content">
                        <h3>Segurança</h3>
                        <p>Gerencie a segurança da sua conta:</p>
                        <ul>
                            <li>Alterar senha</li>
                            <li>Verificação em duas etapas</li>
                            <li>Histórico de acessos</li>
                        </ul>
                    </div>
                </div>

                <div class="card">
                    <div class="card-icon config">
                        <i class="fas fa-cog"></i>
                    </div>
                    <div class="card-content">
                        <h3>Configurações</h3>
                        <p>Personalize sua experiência:</p>
                        <ul>
                            <li>Preferências de notificação</li>
                            <li>Tema da interface</li>
                            <li>Idioma</li>
                        </ul>
                    </div>
                </div>
            </div>
        </section>

        <!-- ==================== NOTIFICAÇÕES ==================== -->
        <section id="notificacoes" class="section">
            <h2 class="section-title">
                <i class="fas fa-bell me-2"></i>Sistema de Notificações
            </h2>
            
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-info-circle"></i>
                    <h3>Como funciona?</h3>
                </div>
                <div class="card-content">
                    <p>O sistema envia notificações importantes sobre suas finanças diretamente no ícone 🔔 do menu.</p>
                </div>
            </div>

            <h3 class="subsection-title">Tipos de notificações</h3>
            
            <div class="notificacao-list">
                <div class="notificacao-item vencimento">
                    <i class="fas fa-exclamation-triangle"></i>
                    <div>
                        <strong>Vencimentos Próximos</strong>
                        <p>Alertas sobre despesas com vencimento nos próximos 7 dias.</p>
                    </div>
                </div>

                <div class="notificacao-item meta">
                    <i class="fas fa-trophy"></i>
                    <div>
                        <strong>Metas Atingidas</strong>
                        <p>Notificação quando você completa um item da lista de desejos.</p>
                    </div>
                </div>

                <div class="notificacao-item alerta">
                    <i class="fas fa-exclamation-circle"></i>
                    <div>
                        <strong>Alertas de Gastos</strong>
                        <p>Avisos quando suas despesas ultrapassam limites definidos.</p>
                    </div>
                </div>
            </div>

            <div class="tip-box">
                <i class="fas fa-lightbulb"></i>
                <div>
                    <strong>Dica:</strong>
                    <p>Clique no × ao lado de cada notificação para removê-la após ler.</p>
                </div>
            </div>
        </section>

        <!-- ==================== DICAS E BOAS PRÁTICAS ==================== -->
        <section id="dicas" class="section">
            <h2 class="section-title">
                <i class="fas fa-lightbulb me-2"></i>Dicas e Boas Práticas
            </h2>
            
            <div class="dicas-grid">
                <div class="dica-card">
                    <div class="dica-icon">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <h4>Registre diariamente</h4>
                    <p>Adicione seus gastos e receitas assim que ocorrerem para não esquecer nenhum lançamento.</p>
                </div>

                <div class="dica-card">
                    <div class="dica-icon">
                        <i class="fas fa-tags"></i>
                    </div>
                    <h4>Use categorias corretamente</h4>
                    <p>Categorize todos os lançamentos para ter relatórios mais precisos e úteis.</p>
                </div>

                <div class="dica-card">
                    <div class="dica-icon">
                        <i class="fas fa-piggy-bank"></i>
                    </div>
                    <h4>Defina metas realistas</h4>
                    <p>Estabeleça objetivos alcançáveis na lista de desejos para manter a motivação.</p>
                </div>

                <div class="dica-card">
                    <div class="dica-icon">
                        <i class="fas fa-chart-line"></i>
                    </div>
                    <h4>Revise mensalmente</h4>
                    <p>Analise seus relatórios todo mês para identificar onde pode economizar.</p>
                </div>

                <div class="dica-card">
                    <div class="dica-icon">
                        <i class="fas fa-redo"></i>
                    </div>
                    <h4>Marque despesas fixas</h4>
                    <p>Use a funcionalidade de despesas fixas para contas recorrentes e não se esqueça delas.</p>
                </div>

                <div class="dica-card">
                    <div class="dica-icon">
                        <i class="fas fa-bell"></i>
                    </div>
                    <h4>Ative as notificações</h4>
                    <p>Fique sempre informado sobre vencimentos e alertas importantes.</p>
                </div>
            </div>
        </section>

        <!-- ==================== SUPORTE ==================== -->
        <section id="suporte" class="section">
            <h2 class="section-title">
                <i class="fas fa-question-circle me-2"></i>Precisa de Ajuda?
            </h2>
            
            <div class="suporte-content">
                <div class="suporte-card">
                    <i class="fas fa-envelope"></i>
                    <h4>Email</h4>
                    <p>contato@seabolso.com</p>
                </div>

                <div class="suporte-card">
                    <i class="fas fa-phone"></i>
                    <h4>Telefone</h4>
                    <p>(47) 99999-9999</p>
                </div>

                <div class="suporte-card">
                    <i class="fas fa-comments"></i>
                    <h4>FAQ</h4>
                    <p><a href="#faq">Perguntas Frequentes</a></p>
                </div>
            </div>
        </section>

    </main>

    <jsp:include page="footer.jsp" />

    <!-- Botão voltar ao topo -->
    <button id="scrollToTop" class="scroll-top-btn" onclick="scrollToTop()">
        <i class="fas fa-arrow-up"></i>
    </button>

    <script src="js/navbar.js"></script>
    <script src="js/manual.js"></script>
</body>

</html>