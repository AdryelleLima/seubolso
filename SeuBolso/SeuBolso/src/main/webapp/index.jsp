<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.Usuario"%>

<%
Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Início - SeuBolso</title>

    <link href="css/main.css" rel="stylesheet" />
    <link href="css/index.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet" />

    <script defer src="js/navbar.js"></script>
    <script defer src="js/index.js"></script>
</head>
<body>
    <!-- Navbar -->
    <jsp:include page="navbar.jsp" />

    <main class="main-container">
        <!-- Hero Section com Boas-vindas -->
        <section class="hero-section">
            <div class="hero-content">
                <div class="hero-text">
                    <h1 class="hero-title">
                        <i class="fas fa-wallet"></i>
                        Bem-vindo ao SeuBolso
                    </h1>
                    <%
                    if (usuario != null) {
                    %>
                    <p class="hero-subtitle">
                        Olá, <strong class="user-name"><%=usuario.getNome()%></strong>! 
                        Seu assistente financeiro pessoal está pronto.
                    </p>
                    <div class="hero-stats">
                        <div class="stat-card">
                            <i class="fas fa-chart-line"></i>
                            <span>Controle Total</span>
                        </div>
                        <div class="stat-card">
                            <i class="fas fa-shield-alt"></i>
                            <span>Seguro</span>
                        </div>
                        <div class="stat-card">
                            <i class="fas fa-mobile-alt"></i>
                            <span>Responsivo</span>
                        </div>
                    </div>
                    <%
                    } else {
                    %>
                    <p class="hero-subtitle">
                        Gerencie suas finanças de forma inteligente e simples.
                    </p>
                    <div class="hero-actions">
                        <a href="login.jsp" class="btn-hero btn-primary">
                            <i class="fas fa-sign-in-alt"></i>
                            Fazer Login
                        </a>
                        <a href="cadastro.jsp" class="btn-hero btn-secondary">
                            <i class="fas fa-user-plus"></i>
                            Cadastre-se Grátis
                        </a>
                    </div>
                    <%
                    }
                    %>
                </div>
                <div class="hero-illustration">
                    <div class="floating-card card-1">
                        <i class="fas fa-coins"></i>
                        <span>Receitas</span>
                    </div>
                    <div class="floating-card card-2">
                        <i class="fas fa-chart-pie"></i>
                        <span>Relatórios</span>
                    </div>
                    <div class="floating-card card-3">
                        <i class="fas fa-bullseye"></i>
                        <span>Metas</span>
                    </div>
                </div>
            </div>
        </section>

        <!-- Carrossel de Imagens -->
        <section class="carousel-section">
            <h2 class="section-title">
                <i class="fas fa-images"></i>
                Conheça o SeuBolso
            </h2>
            <div class="carousel-container">
                <div class="carousel-wrapper">
                    <button class="carousel-btn prev-btn" aria-label="Anterior">
                        <i class="fas fa-chevron-left"></i>
                    </button>
                    <div class="carousel-slide">
                        <div class="carousel-item active">
                            <img src="img/painel.png" alt="Painel de Controle" />
                            <div class="carousel-caption">
                                <h3>Dashboard Completo</h3>
                                <p>Visualize todas as suas finanças em um só lugar</p>
                            </div>
                        </div>
                        <div class="carousel-item">
                            <img src="img/PROCESSO-DE-PLANEJAMENTO-FINANCEIRO.png" alt="Planejamento Financeiro" />
                            <div class="carousel-caption">
                                <h3>Planejamento Inteligente</h3>
                                <p>Organize suas metas e conquiste seus objetivos</p>
                            </div>
                        </div>
                    </div>
                    <button class="carousel-btn next-btn" aria-label="Próximo">
                        <i class="fas fa-chevron-right"></i>
                    </button>
                </div>
                <div class="carousel-indicators"></div>
            </div>
        </section>

        <!-- Seção de Funcionalidades -->
        <section class="features-section">
            <h2 class="section-title">
                <i class="fas fa-star"></i>
                Funcionalidades Principais
            </h2>
            <div class="features-grid">
                <!-- Dashboard -->
                <div class="feature-card" data-aos="fade-up">
                    <div class="feature-icon dashboard">
                        <i class="fas fa-tachometer-alt"></i>
                    </div>
                    <h3>Dashboard</h3>
                    <p>Visão completa das suas finanças com gráficos interativos, saldo atualizado e alertas importantes.</p>
                    <div class="feature-tags">
                        <span class="tag">Saldo em Tempo Real</span>
                        <span class="tag">Gráficos</span>
                    </div>
                </div>

                <!-- Calendário -->
                <div class="feature-card" data-aos="fade-up" data-aos-delay="100">
                    <div class="feature-icon calendar">
                        <i class="fas fa-calendar-alt"></i>
                    </div>
                    <h3>Calendário</h3>
                    <p>Visualize todos os lançamentos de receitas e despesas organizados por data, incluindo despesas fixas.</p>
                    <div class="feature-tags">
                        <span class="tag">Organização</span>
                        <span class="tag">Despesas Fixas</span>
                    </div>
                </div>

                <!-- Lançamentos -->
                <div class="feature-card" data-aos="fade-up" data-aos-delay="200">
                    <div class="feature-icon launch">
                        <i class="fas fa-plus-circle"></i>
                    </div>
                    <h3>Lançamentos</h3>
                    <p>Registre rapidamente novas receitas ou despesas com categorização automática e campos inteligentes.</p>
                    <div class="feature-tags">
                        <span class="tag">Rápido</span>
                        <span class="tag">Categorização</span>
                    </div>
                </div>

                <!-- Lista de Desejos -->
                <div class="feature-card" data-aos="fade-up" data-aos-delay="300">
                    <div class="feature-icon wishlist">
                        <i class="fas fa-bullseye"></i>
                    </div>
                    <h3>Lista de Desejos</h3>
                    <p>Defina metas financeiras e acompanhe o progresso para realizar seus sonhos e conquistas.</p>
                    <div class="feature-tags">
                        <span class="tag">Metas</span>
                        <span class="tag">Progresso</span>
                    </div>
                </div>

                <!-- Relatórios -->
                <div class="feature-card" data-aos="fade-up" data-aos-delay="400">
                    <div class="feature-icon reports">
                        <i class="fas fa-file-chart-line"></i>
                    </div>
                    <h3>Relatórios</h3>
                    <p>Gere relatórios detalhados filtrando por período, categoria e tipo para análises precisas.</p>
                    <div class="feature-tags">
                        <span class="tag">Filtros Avançados</span>
                        <span class="tag">Análises</span>
                    </div>
                </div>

                <!-- Segurança -->
                <div class="feature-card" data-aos="fade-up" data-aos-delay="500">
                    <div class="feature-icon security">
                        <i class="fas fa-lock"></i>
                    </div>
                    <h3>Segurança</h3>
                    <p>Seus dados protegidos com criptografia e sistema de sessão seguro. Privacidade garantida.</p>
                    <div class="feature-tags">
                        <span class="tag">Criptografia</span>
                        <span class="tag">Privado</span>
                    </div>
                </div>
            </div>
        </section>

        <!-- Seção Como Funciona -->
        <section class="how-it-works-section">
            <h2 class="section-title">
                <i class="fas fa-question-circle"></i>
                Como Funciona?
            </h2>
            <div class="steps-container">
                <div class="step-card">
                    <div class="step-number">1</div>
                    <div class="step-icon">
                        <i class="fas fa-user-plus"></i>
                    </div>
                    <h3>Crie sua Conta</h3>
                    <p>Cadastre-se gratuitamente em menos de 1 minuto</p>
                </div>

                <div class="step-arrow">
                    <i class="fas fa-arrow-right"></i>
                </div>

                <div class="step-card">
                    <div class="step-number">2</div>
                    <div class="step-icon">
                        <i class="fas fa-wallet"></i>
                    </div>
                    <h3>Registre Transações</h3>
                    <p>Adicione suas receitas e despesas facilmente</p>
                </div>

                <div class="step-arrow">
                    <i class="fas fa-arrow-right"></i>
                </div>

                <div class="step-card">
                    <div class="step-number">3</div>
                    <div class="step-icon">
                        <i class="fas fa-chart-line"></i>
                    </div>
                    <h3>Acompanhe Resultados</h3>
                    <p>Visualize gráficos e tome decisões inteligentes</p>
                </div>
            </div>
        </section>

        <!-- CTA Final -->
        <%
        if (usuario == null) {
        %>
        <section class="cta-section">
            <div class="cta-content">
                <h2>Pronto para Transformar suas Finanças?</h2>
                <p>Junte-se a milhares de usuários que já controlam melhor seu dinheiro</p>
                <a href="cadastro.jsp" class="btn-cta">
                    <i class="fas fa-rocket"></i>
                    Começar Agora - É Grátis
                </a>
            </div>
        </section>
        <%
        }
        %>
    </main>

    <jsp:include page="footer.jsp" />
</body>
</html>