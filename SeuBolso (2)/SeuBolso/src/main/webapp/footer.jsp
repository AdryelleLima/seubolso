<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate"%>

<footer class="footer-container">
    <link href="css/footer.css" rel="stylesheet" />
    
    <div class="footer-content">
        <!-- Coluna 1: Logo e Descrição -->
        <div class="footer-section">
            <div class="footer-logo">
                <img src="img/logo.png" alt="SeuBolso Logo" class="footer-marca" />
                <h3>SeuBolso</h3>
            </div>
            <p class="footer-description">
                Seu assistente pessoal de finanças. Controle seus gastos, 
                planeje seu futuro e alcance seus objetivos financeiros.
            </p>
            
        </div>

        <!-- Coluna 2: Links Rápidos -->
        <div class="footer-section">
            <h4>Links Rápidos</h4>
            <ul class="footer-links">
                <li><a href="Home.jsp">Visão Geral</a></li>
                <li><a href="calendario.jsp">Calendário</a></li>
                <li><a href="lancamento.jsp">Lançamentos</a></li>
                <li><a href="ListaDesejosServlet">Lista de Desejos</a></li>
                <li><a href="relatorio.jsp">Relatórios</a></li>
            </ul>
        </div>

        <!-- Coluna 3: Suporte -->
     <!--   <div class="footer-section">
            <h4>Suporte</h4>
            <ul class="footer-links">
                <li><a href="manual.jsp">Manual do Usuário</a></li>
                <li><a href="#faq">Perguntas Frequentes</a></li>
                <li><a href="#contato">Fale Conosco</a></li>
                <li><a href="#termos">Termos de Uso</a></li>
                <li><a href="#privacidade">Política de Privacidade</a></li>
            </ul>
        </div> -->

        <!-- Coluna 4: Contato -->
        <div class="footer-section">
            <h4>Contato</h4>
            <ul class="footer-contact">
                <li>
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4l-8 5-8-5V6l8 5 8-5v2z"/>
                    </svg>
                    <a href="mailto:contato@seabolso.com">contato@seabolso.com</a>
                </li>
                <li>
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M6.62 10.79c1.44 2.83 3.76 5.14 6.59 6.59l2.2-2.2c.27-.27.67-.36 1.02-.24 1.12.37 2.33.57 3.57.57.55 0 1 .45 1 1V20c0 .55-.45 1-1 1-9.39 0-17-7.61-17-17 0-.55.45-1 1-1h3.5c.55 0 1 .45 1 1 0 1.25.2 2.45.57 3.57.11.35.03.74-.25 1.02l-2.2 2.2z"/>
                    </svg>
                    <span>(47) 99999-9999</span>
                </li>
                <li>
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/>
                    </svg>
                    <span>Blumenau, SC - Brasil</span>
                </li>
            </ul>
        </div>
    </div>

    <!-- Linha divisória -->
    <div class="footer-divider"></div>

    <!-- Rodapé inferior -->
    <div class="footer-bottom">
        <p class="footer-copyright">
            © <%= LocalDate.now().getYear() %> SeuBolso - Controle Financeiro. Todos os direitos reservados.
        </p>
        <p class="footer-dev">
            Desenvolvido com <span class="heart">❤️</span> por SeuBolso Team
        </p>
    </div>
</footer>