document.addEventListener("DOMContentLoaded", () => {
  // ================= CARROSSEL =================
  const carroselSlide = document.querySelector(".carrosel-slide");
  const carroselItems = document.querySelectorAll(".carrosel-item");
  const indicadoresContainer = document.querySelector(".carrosel-indicadores");

  // Só executa se os elementos do carrossel existirem
  if (carroselSlide && carroselItems.length > 0 && indicadoresContainer) {
    let counter = 0;

    function getItemWidth() { return carroselItems[0].clientWidth; }
    function moveCarrosel() { carroselSlide.style.transform = `translateX(${-getItemWidth() * counter}px)`; }

    // Criar indicadores
    function criarIndicadores() {
      indicadoresContainer.innerHTML = "";
      carroselItems.forEach((_, idx) => {
        const dot = document.createElement("span");
        dot.classList.add("carrosel-dot");
        if (idx === counter) dot.classList.add("active");
        dot.addEventListener("click", () => {
          counter = idx;
          moveCarrosel();
          updateIndicators();
        });
        indicadoresContainer.appendChild(dot);
      });
    }

    function updateIndicators() {
      const dots = indicadoresContainer.querySelectorAll(".carrosel-dot");
      dots.forEach((dot, idx) => dot.classList.toggle("active", idx === counter));
    }

    criarIndicadores();
    moveCarrosel();

    // Autoplay
    let autoInterval = setInterval(() => {
      counter = (counter + 1) % carroselItems.length;
      moveCarrosel();
      updateIndicators();
    }, 8000);

    indicadoresContainer.addEventListener("mouseenter", () => clearInterval(autoInterval));
    indicadoresContainer.addEventListener("mouseleave", () => {
      autoInterval = setInterval(() => {
        counter = (counter + 1) % carroselItems.length;
        moveCarrosel();
        updateIndicators();
      }, 8000);
    });

    window.addEventListener("resize", moveCarrosel);
  }

  // ================= POPOVERS =================
  function initPopover(btnId, popoverId, fecharId) {
    const btn = document.getElementById(btnId);
    const popover = document.getElementById(popoverId);
    const fechar = document.getElementById(fecharId);
    if (!btn || !popover || !fechar) return;

    const abrir = (e) => {
      e.preventDefault();
      const rect = btn.getBoundingClientRect();
      popover.style.display = "block";
      let top = rect.bottom + window.scrollY + 8;
      let left = rect.left + window.scrollX;
      const w = popover.offsetWidth || 240;
      const h = popover.offsetHeight || 120;
      const vw = window.innerWidth;
      const vh = window.innerHeight;
      if (left + w > vw) left = vw - w - 16;
      if (top + h > vh) top = rect.top + window.scrollY - h - 8;
      popover.style.top = top + "px";
      popover.style.left = left + "px";
    };

    const fecharFunc = () => popover.style.display = "none";

    btn.addEventListener("click", abrir);
    fechar.addEventListener("click", fecharFunc);

    document.addEventListener("mousedown", (e) => {
      if (popover.style.display === "block" && !popover.contains(e.target) && e.target !== btn) {
        fecharFunc();
      }
    });
  }

  initPopover("configuracao-btn", "popover-configuracao", "fechar-popover-config");
  initPopover("notificacao-btn", "popover-notificacao", "fechar-popover-notificacao");

  // ================= TOAST =================
  function ensureToastContainer() {
    let container = document.querySelector(".toast-container");
    if (!container) {
      container = document.createElement("div");
      container.className = "toast-container";
      document.body.appendChild(container);
    }
    return container;
  }

  window.showToast = function(message, type = "info") {
    const container = ensureToastContainer();
    const toast = document.createElement("div");
    toast.className = `toast ${type}`;
    toast.textContent = message;
    container.appendChild(toast);
    setTimeout(() => toast.remove(), 4000);
  };

  // ================= NOTIFICAÇÕES DINÂMICAS =================
  const notificacoes = [
    "Seu objetivo está próximo de ser atingido!",
    "Você tem uma nova mensagem do suporte."
  ];

  const ulNotificacoes = document.getElementById("notificacao-lista");
  if (ulNotificacoes) {
    ulNotificacoes.innerHTML = "";
    if (notificacoes.length === 0) {
      const li = document.createElement("li");
      li.textContent = "Nenhuma nova notificação.";
      ulNotificacoes.appendChild(li);
    } else {
      notificacoes.forEach(msg => {
        const li = document.createElement("li");
        li.textContent = msg;
        ulNotificacoes.appendChild(li);
      });
    }
  }
});