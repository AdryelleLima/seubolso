// ========================= INICIALIZAÇÃO =========================
document.addEventListener('DOMContentLoaded', function() {
    inicializarGrafico();
    inicializarScrollToTop();
});

// ========================= GRÁFICO DE PIZZA =========================
function inicializarGrafico() {
    const ctx = document.getElementById('grafico-financeiro');
    if (!ctx) return;

    const receitas = typeof receitaMensal !== 'undefined' ? receitaMensal : 0;
    const despesas = typeof despesaMensal !== 'undefined' ? despesaMensal : 0;

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

    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Receitas', 'Despesas'],
            datasets: [{
                data: [receitas, despesas],
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

// ========================= SCROLL TO TOP =========================
function inicializarScrollToTop() {
    const scrollBtn = document.getElementById('scrollToTop');
    if (!scrollBtn) return;

    // Mostrar/ocultar botão baseado na posição do scroll
    window.addEventListener('scroll', function() {
        if (window.pageYOffset > 300) {
            scrollBtn.classList.add('show');
        } else {
            scrollBtn.classList.remove('show');
        }
    });
}

function scrollToTop() {
    window.scrollTo({
        top: 0,
        behavior: 'smooth'
    });
}

// ========================= ANIMAÇÕES DE ENTRADA =========================
// Adiciona animação de fade-in aos elementos quando eles entram na viewport
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

// Observar elementos que devem ter animação
document.addEventListener('DOMContentLoaded', function() {
    const animatedElements = document.querySelectorAll('.section-latest, .section-form');
    animatedElements.forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(20px)';
        el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(el);
    });
});