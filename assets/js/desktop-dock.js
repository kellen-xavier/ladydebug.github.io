(function () {
  var dock = document.querySelector(".dock");
  if (!dock) return;

  var openOffset = 0;
  var topZ = 50;

  function navbarHeight() {
    var nav = document.querySelector(".hextra-nav-container");
    return nav ? nav.offsetHeight : 0;
  }

  function raiseWindow(win) {
    topZ += 1;
    win.style.zIndex = topZ;
  }

  function placeWindow(win, anchorBtn) {
    var margin = 16;
    var gapAboveDock = 12;
    var dockHeight = dock.offsetHeight;
    var width = win.offsetWidth || 352;
    var height = win.offsetHeight || 280;

    // Ancora perto do ícone clicado, horizontalmente; verticalmente sempre
    // colada acima da doca (nunca perto do cabeçalho).
    var left = margin + openOffset;
    if (anchorBtn) {
      var rect = anchorBtn.getBoundingClientRect();
      left = rect.left + rect.width / 2 - width / 2 + openOffset;
    }
    var top = window.innerHeight - dockHeight - gapAboveDock - height - openOffset;

    var maxLeft = window.innerWidth - width - margin;
    var maxTop = window.innerHeight - dockHeight - gapAboveDock - height;
    var minTop = navbarHeight() + margin;
    left = Math.min(maxLeft, Math.max(margin, left));
    top = Math.min(maxTop, Math.max(minTop, top));

    win.style.left = left + "px";
    win.style.top = top + "px";
    openOffset = (openOffset + 40) % 120;
  }

  function loadEmbed(win) {
    var body = win.querySelector("[data-embed-src]");
    if (!body || body.dataset.loaded) return;
    var iframe = document.createElement("iframe");
    iframe.src = body.dataset.embedSrc;
    iframe.loading = "lazy";
    iframe.allow = "encrypted-media";
    body.appendChild(iframe);
    body.dataset.loaded = "true";
  }

  function openWindow(win, anchorBtn) {
    if (win.open) return;
    win.show();
    loadEmbed(win);
    placeWindow(win, anchorBtn);
    raiseWindow(win);
  }

  function closeWindow(win) {
    if (win.open) win.close();
  }

  dock.addEventListener("click", function (event) {
    var btn = event.target.closest("[data-dock-target]");
    if (!btn) return;
    var win = document.getElementById(btn.getAttribute("data-dock-target"));
    if (!win) return;

    if (win.open) {
      closeWindow(win);
      btn.setAttribute("aria-pressed", "false");
    } else {
      openWindow(win, btn);
      btn.setAttribute("aria-pressed", "true");
    }
  });

  document.querySelectorAll(".dock-window").forEach(function (win) {
    var btn = dock.querySelector(
      '[data-dock-target="' + win.id + '"]'
    );

    win.addEventListener("close", function () {
      if (btn) btn.setAttribute("aria-pressed", "false");
    });

    win.addEventListener("pointerdown", function () {
      raiseWindow(win);
    });

    var closeBtn = win.querySelector("[data-dock-close]");
    if (closeBtn) {
      closeBtn.addEventListener("click", function () {
        closeWindow(win);
      });
    }

    var bar = win.querySelector(".dock-window__bar");
    if (!bar) return;

    var dragging = false;
    var startX = 0;
    var startY = 0;
    var startLeft = 0;
    var startTop = 0;

    bar.addEventListener("pointerdown", function (event) {
      if (event.target.closest("[data-dock-close]")) return;
      dragging = true;
      startX = event.clientX;
      startY = event.clientY;
      var rect = win.getBoundingClientRect();
      startLeft = rect.left;
      startTop = rect.top;
      bar.setPointerCapture(event.pointerId);
    });

    bar.addEventListener("pointermove", function (event) {
      if (!dragging) return;
      var minTop = navbarHeight();
      var left = startLeft + (event.clientX - startX);
      var top = startTop + (event.clientY - startY);
      win.style.left = Math.max(0, left) + "px";
      win.style.top = Math.max(minTop, top) + "px";
    });

    function stopDrag(event) {
      dragging = false;
      if (bar.hasPointerCapture(event.pointerId)) {
        bar.releasePointerCapture(event.pointerId);
      }
    }

    bar.addEventListener("pointerup", stopDrag);
    bar.addEventListener("pointercancel", stopDrag);
  });
})();
