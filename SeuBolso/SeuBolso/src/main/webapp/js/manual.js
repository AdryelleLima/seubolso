// ==================== AGUARDA CARREGAMENTO COMPLETO ====================
document.addEventListener('DOMContentLoaded', function() {
    console.log('Manual do Usuário inicializado');
    
    // ==================== SCROLL TO TOP ====================
    const scrollBtn = document.getElementById('scrollToTop');
    
    // Mostra/esconde botão de scroll to top
    window.addEventListener('scroll', function() {
        if (scrollBtn) {
            if (window.pageYOffset > 300) {
                scrollBtn.classList.add('show');
            } else {
                scrollBtn.classList.remove('show');
            }
        }
    });
    
    // ==================== SMOOTH SCROLL PARA NAVEGAÇÃO ====================
    const navLinks = document.querySelectorAll('.nav-links a');
    
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            
            const targetId = this.getAttribute('href');
            const targetSection = document.querySelector(targetId);
            
            if (targetSection) {
                // Offset para considerar a navbar fixa (100px)
                const offsetTop = targetSection.offsetTop - 100;
                
                window.scrollTo({
                    top: offsetTop,
                    behavior: 'smooth'
                });
            }
        });
    });
    
    // ==================== DESTAQUE DA SEÇÃO ATIVA ====================
    const sections = document.querySelectorAll('.section');
    
    function updateActiveSection() {
        let current = '';
        const scrollPos = window.pageYOffset + 150;
        
        sections.forEach(section => {
            const sectionTop = section.offsetTop;
            const sectionHeight = section.clientHeight;
            
            if (scrollPos >= sectionTop && scrollPos < sectionTop + sectionHeight) {
                current = section.getAttribute('id');
            }
        });
        
        // Remove destaque de todos os links
        navLinks.forEach(link => {
            const href = link.getAttribute('href').substring(1);
            
            if (href === current) {
                link.style.background = 'linear-gradient(135deg, #009c3b 0%, #00b359 100%)';
                link.style.color = 'white';
                link.style.fontWeight = '700';
            } else {
                link.style.background = '#f8f9fa';
                link.style.color = '#2c3e50';
                link.style.fontWeight = '500';
            }
        });
    }
    
    window.addEventListener('scroll', updateActiveSection);
    updateActiveSection(); // Chama uma vez no carregamento
    
    // ==================== ANIMAÇÃO DE ENTRADA DOS CARDS ====================
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);
    
    // Observa todos os cards e steps
    const animatedElements = document.querySelectorAll('.card, .step, .dica-card, .suporte-card, .notificacao-item');
    
    animatedElements.forEach(element => {
        element.style.opacity = '0';
        element.style.transform = 'translateY(20px)';
        element.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(element);
    });
    
    // ==================== COPIAR EMAIL/TELEFONE ====================
    const suporteCards = document.querySelectorAll('.suporte-card p');
    
    suporteCards.forEach(card => {
        const text = card.textContent.trim();
        
        if (text.includes('@') || text.includes('(')) {
            card.style.cursor = 'pointer';
            card.title = 'Clique para copiar';
            
            card.addEventListener('click', function() {
                const textToCopy = this.textContent.trim();
                
                // Tenta copiar para clipboard
                if (navigator.clipboard && navigator.clipboard.writeText) {
                    navigator.clipboard.writeText(textToCopy).then(() => {
                        showCopyFeedback(this);
                    }).catch(err => {
                        console.error('Erro ao copiar:', err);
                        fallbackCopy(textToCopy, this);
                    });
                } else {
                    fallbackCopy(textToCopy, this);
                }
            });
        }
    });
    
    function showCopyFeedback(element) {
        const originalText = element.textContent;
        const originalColor = element.style.color;
        
        element.textContent = '✓ Copiado!';
        element.style.color = '#27ae60';
        element.style.fontWeight = 'bold';
        
        setTimeout(() => {
            element.textContent = originalText;
            element.style.color = originalColor;
            element.style.fontWeight = 'normal';
        }, 2000);
    }
    
    function fallbackCopy(text, element) {
        // Fallback para navegadores antigos
        const textArea = document.createElement('textarea');
        textArea.value = text;
        textArea.style.position = 'fixed';
        textArea.style.left = '-999999px';
        document.body.appendChild(textArea);
        textArea.select();
        
        try {
            document.execCommand('copy');
            showCopyFeedback(element);
        } catch (err) {
            console.error('Erro ao copiar:', err);
        }
        
        document.body.removeChild(textArea);
    }
    
    // ==================== SCROLL SUAVE EM TODOS OS LINKS INTERNOS ====================
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            const href = this.getAttribute('href');
            
            if (href !== '#' && href.length > 1) {
                e.preventDefault();
                const target = document.querySelector(href);
                
                if (target) {
                    const offsetTop = target.offsetTop - 100;
                    window.scrollTo({
                        top: offsetTop,
                        behavior: 'smooth'
                    });
                }
            }
        });
    });
    
    console.log('Manual do Usuário carregado com sucesso! ✓');
});

// ==================== FUNÇÃO GLOBAL PARA SCROLL TO TOP ====================
function scrollToTop() {
    window.scrollTo({
        top: 0,
        behavior: 'smooth'
    });
}