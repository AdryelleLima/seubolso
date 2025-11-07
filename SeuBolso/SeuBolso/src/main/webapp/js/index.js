// ========================= INICIALIZAÇÃO =========================
document.addEventListener("DOMContentLoaded", function () {
    console.log('🚀 SeuBolso - Página inicial carregada');
    
    initCarousel();
    initScrollAnimations();
    initSmoothScroll();
});

// ========================= CARROSSEL =========================
function initCarousel() {
    const carouselSlide = document.querySelector('.carousel-slide');
    const carouselItems = document.querySelectorAll('.carousel-item');
    const prevBtn = document.querySelector('.prev-btn');
    const nextBtn = document.querySelector('.next-btn');
    const indicatorsContainer = document.querySelector('.carousel-indicators');
    
    if (!carouselSlide || carouselItems.length === 0) {
        console.warn('⚠️ Elementos do carrossel não encontrados');
        return;
    }
    
    let currentIndex = 0;
    const totalItems = carouselItems.length;
    let autoPlayInterval;
    
    // Criar indicadores
    createIndicators();
    
    // Iniciar no primeiro item
    updateCarousel();
    
    // Event listeners para botões
    if (prevBtn) {
        prevBtn.addEventListener('click', () => {
            goToPrevious();
            resetAutoPlay();
        });
    }
    
    if (nextBtn) {
        nextBtn.addEventListener('click', () => {
            goToNext();
            resetAutoPlay();
        });
    }
    
    // Iniciar autoplay
    startAutoPlay();
    
    // Pausar autoplay ao passar o mouse
    const carouselContainer = document.querySelector('.carousel-container');
    if (carouselContainer) {
        carouselContainer.addEventListener('mouseenter', stopAutoPlay);
        carouselContainer.addEventListener('mouseleave', startAutoPlay);
    }
    
    // Suporte a touch/swipe em dispositivos móveis
    let touchStartX = 0;
    let touchEndX = 0;
    
    if (carouselSlide) {
        carouselSlide.addEventListener('touchstart', (e) => {
            touchStartX = e.changedTouches[0].screenX;
        });
        
        carouselSlide.addEventListener('touchend', (e) => {
            touchEndX = e.changedTouches[0].screenX;
            handleSwipe();
        });
    }
    
    function handleSwipe() {
        const swipeThreshold = 50;
        const diff = touchStartX - touchEndX;
        
        if (Math.abs(diff) > swipeThreshold) {
            if (diff > 0) {
                goToNext();
            } else {
                goToPrevious();
            }
            resetAutoPlay();
        }
    }
    
    function createIndicators() {
        if (!indicatorsContainer) return;
        
        indicatorsContainer.innerHTML = '';
        
        for (let i = 0; i < totalItems; i++) {
            const indicator = document.createElement('div');
            indicator.classList.add('indicator');
            if (i === 0) indicator.classList.add('active');
            
            indicator.addEventListener('click', () => {
                currentIndex = i;
                updateCarousel();
                resetAutoPlay();
            });
            
            indicatorsContainer.appendChild(indicator);
        }
    }
    
    function updateCarousel() {
        // Remover classe active de todos os itens
        carouselItems.forEach(item => {
            item.classList.remove('active');
        });
        
        // Adicionar classe active ao item atual
        carouselItems[currentIndex].classList.add('active');
        
        // Atualizar indicadores
        const indicators = document.querySelectorAll('.indicator');
        indicators.forEach((indicator, index) => {
            if (index === currentIndex) {
                indicator.classList.add('active');
            } else {
                indicator.classList.remove('active');
            }
        });
        
        // Transformar o slide
        const offset = -currentIndex * 100;
        carouselSlide.style.transform = `translateX(${offset}%)`;
    }
    
    function goToNext() {
        currentIndex = (currentIndex + 1) % totalItems;
        updateCarousel();
    }
    
    function goToPrevious() {
        currentIndex = (currentIndex - 1 + totalItems) % totalItems;
        updateCarousel();
    }
    
    function startAutoPlay() {
        stopAutoPlay(); // Limpar qualquer intervalo existente
        autoPlayInterval = setInterval(() => {
            goToNext();
        }, 5000); // Trocar a cada 5 segundos
    }
    
    function stopAutoPlay() {
        if (autoPlayInterval) {
            clearInterval(autoPlayInterval);
            autoPlayInterval = null;
        }
    }
    
    function resetAutoPlay() {
        stopAutoPlay();
        startAutoPlay();
    }
    
    // Pausar autoplay quando a aba não está visível
    document.addEventListener('visibilitychange', () => {
        if (document.hidden) {
            stopAutoPlay();
        } else {
            startAutoPlay();
        }
    });
}

// ========================= ANIMAÇÕES DE SCROLL =========================
function initScrollAnimations() {
    // Observador de interseção para animações ao rolar
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -100px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('aos-animate');
                
                // Adicionar efeito de contador aos cards de estatística
                if (entry.target.classList.contains('stat-card')) {
                    animateStatCard(entry.target);
                }
            }
        });
    }, observerOptions);
    
    // Observar todos os elementos com animação
    const animatedElements = document.querySelectorAll('[data-aos]');
    animatedElements.forEach(el => observer.observe(el));
    
    // Observar cards de funcionalidades
    const featureCards = document.querySelectorAll('.feature-card');
    featureCards.forEach(card => observer.observe(card));
    
    // Observar steps
    const stepCards = document.querySelectorAll('.step-card');
    stepCards.forEach(card => observer.observe(card));
}

function animateStatCard(card) {
    // Adicionar animação de entrada suave
    card.style.opacity = '0';
    card.style.transform = 'translateY(20px)';
    
    setTimeout(() => {
        card.style.transition = 'all 0.6s ease';
        card.style.opacity = '1';
        card.style.transform = 'translateY(0)';
    }, 100);
}

// ========================= SCROLL SUAVE =========================
function initSmoothScroll() {
    // Adicionar scroll suave para links internos
    const links = document.querySelectorAll('a[href^="#"]');
    
    links.forEach(link => {
        link.addEventListener('click', (e) => {
            const href = link.getAttribute('href');
            
            // Ignorar # vazio
            if (href === '#') return;
            
            e.preventDefault();
            
            const target = document.querySelector(href);
            if (target) {
                const offsetTop = target.offsetTop - 80; // 80px de offset para a navbar
                
                window.scrollTo({
                    top: offsetTop,
                    behavior: 'smooth'
                });
            }
        });
    });
}

// ========================= EFEITOS VISUAIS =========================
// Parallax suave no hero
window.addEventListener('scroll', () => {
    const scrolled = window.pageYOffset;
    const heroSection = document.querySelector('.hero-section');
    
    if (heroSection && scrolled < window.innerHeight) {
        heroSection.style.transform = `translateY(${scrolled * 0.3}px)`;
        heroSection.style.opacity = 1 - (scrolled / window.innerHeight) * 0.5;
    }
});

// Efeito de hover nos cards de funcionalidades
document.querySelectorAll('.feature-card').forEach(card => {
    card.addEventListener('mouseenter', function() {
        // Adicionar efeito de brilho
        this.style.background = 'linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%)';
    });
    
    card.addEventListener('mouseleave', function() {
        this.style.background = 'var(--white)';
    });
});

// ========================= UTILITÁRIOS =========================
// Detectar se é dispositivo móvel
function isMobileDevice() {
    return window.innerWidth <= 768 || 
           /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
}

// Log de performance
console.log('📊 Tempo de carregamento:', performance.now().toFixed(2) + 'ms');

// Adicionar indicador de loading se necessário
window.addEventListener('load', () => {
    document.body.classList.add('loaded');
    console.log('✅ Todos os recursos carregados');
});

// ========================= EASTER EGG =========================
// Easter egg: Konami Code
let konamiCode = [];
const konamiSequence = ['ArrowUp', 'ArrowUp', 'ArrowDown', 'ArrowDown', 'ArrowLeft', 'ArrowRight', 'ArrowLeft', 'ArrowRight', 'b', 'a'];

document.addEventListener('keydown', (e) => {
    konamiCode.push(e.key);
    konamiCode = konamiCode.slice(-10);
    
    if (konamiCode.join(',') === konamiSequence.join(',')) {
        activateEasterEgg();
        konamiCode = [];
    }
});

function activateEasterEgg() {
    console.log('🎉 Konami Code ativado!');
    
    // Adicionar confetti ou efeito especial
    document.body.style.animation = 'rainbow 2s ease infinite';
    
    setTimeout(() => {
        document.body.style.animation = '';
    }, 5000);
}

// Adicionar animação rainbow ao CSS dinamicamente
const style = document.createElement('style');
style.textContent = `
    @keyframes rainbow {
        0% { filter: hue-rotate(0deg); }
        100% { filter: hue-rotate(360deg); }
    }
`;
document.head.appendChild(style);

// ========================= MENSAGENS DE CONSOLE =========================
console.log('%c🎨 SeuBolso - Sistema de Controle Financeiro', 
    'font-size: 20px; font-weight: bold; color: #1a4d2e; text-shadow: 2px 2px 4px rgba(0,0,0,0.2);');
console.log('%c💚 Desenvolvido com dedicação pelo time Jovem Programador', 
    'font-size: 14px; color: #2d6a4f;');
console.log('%c⚡ Performance: ' + performance.now().toFixed(2) + 'ms', 
    'font-size: 12px; color: #4caf50;');