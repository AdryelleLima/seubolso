document.addEventListener('DOMContentLoaded', function() {
    
    // ===============================
    // 🎠 CARROSSEL
    // ===============================
    const carrosel = document.querySelector('.carrosel');
    const carroselSlide = document.querySelector('.carrosel-slide');
    const carroselItems = document.querySelectorAll('.carrosel-item');
    const indicadoresContainer = document.querySelector('.carrosel-indicadores');
    
    if (carrosel && carroselSlide && carroselItems.length > 0) {
        let currentIndex = 0;
        const totalItems = carroselItems.length;
        
        // Cria indicadores
        carroselItems.forEach((_, index) => {
            const indicador = document.createElement('div');
            indicador.className = 'carrosel-indicador';
            if (index === 0) indicador.classList.add('active');
            
            indicador.addEventListener('click', () => {
                goToSlide(index);
            });
            
            indicadoresContainer.appendChild(indicador);
        });
        
        const indicadores = document.querySelectorAll('.carrosel-indicador');
        
        // Função para ir para um slide específico
        function goToSlide(index) {
            currentIndex = index;
            carroselSlide.style.transform = `translateX(-${currentIndex * 100}%)`;
            
            // Atualiza indicadores
            indicadores.forEach((ind, i) => {
                if (i === currentIndex) {
                    ind.classList.add('active');
                } else {
                    ind.classList.remove('active');
                }
            });
        }
        
        // Função para próximo slide
        function nextSlide() {
            currentIndex = (currentIndex + 1) % totalItems;
            goToSlide(currentIndex);
        }
        
        // Auto-play: muda de slide a cada 5 segundos
        let autoplayInterval = setInterval(nextSlide, 5000);
        
        // Pausa auto-play quando mouse está sobre o carrossel
        carrosel.addEventListener('mouseenter', () => {
            clearInterval(autoplayInterval);
        });
        
        // Retoma auto-play quando mouse sai do carrossel
        carrosel.addEventListener('mouseleave', () => {
            autoplayInterval = setInterval(nextSlide, 5000);
        });
        
        // Suporte para swipe em dispositivos móveis
        let touchStartX = 0;
        let touchEndX = 0;
        
        carrosel.addEventListener('touchstart', (e) => {
            touchStartX = e.changedTouches[0].screenX;
        });
        
        carrosel.addEventListener('touchend', (e) => {
            touchEndX = e.changedTouches[0].screenX;
            handleSwipe();
        });
        
        function handleSwipe() {
            const swipeThreshold = 50;
            const diff = touchStartX - touchEndX;
            
            if (Math.abs(diff) > swipeThreshold) {
                if (diff > 0) {
                    // Swipe left - próximo
                    nextSlide();
                } else {
                    // Swipe right - anterior
                    currentIndex = (currentIndex - 1 + totalItems) % totalItems;
                    goToSlide(currentIndex);
                }
            }
        }
        
        // Suporte para navegação por teclado
        document.addEventListener('keydown', (e) => {
            if (e.key === 'ArrowLeft') {
                currentIndex = (currentIndex - 1 + totalItems) % totalItems;
                goToSlide(currentIndex);
            } else if (e.key === 'ArrowRight') {
                nextSlide();
            }
        });
    }
    
    // ===============================
    // 🎨 ANIMAÇÃO DOS CARDS AO SCROLL
    // ===============================
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('.manual-card').forEach(card => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(card);
    });
});