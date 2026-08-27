(function () {
  var dock = document.querySelector(".dock");
  if (!dock) return;

  var openOffset = 0;

  function placeWindow(win) {
    var margin = 16;
    var width = win.offsetWidth || 352;
    var height = win.offsetHeight || 280;
    var maxLeft = window.innerWidth - width - margin;
    var maxTop = window.innerHeight - height - margin;
    var left = Math.min(maxLeft, margin + openOffset);
    var top = Math.min(maxTop, margin + openOffset);
    win.style.left = Math.max(margin, left) + "px";
    win.style.top = Math.max(margin, top) + "px";
    openOffset = (openOffset + 24) % 96;
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

  function openWindow(win) {
    if (win.open) return;
    win.show();
    placeWindow(win);
    loadEmbed(win);
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
      openWindow(win);
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
      var left = startLeft + (event.clientX - startX);
      var top = startTop + (event.clientY - startY);
      win.style.left = Math.max(0, left) + "px";
      win.style.top = Math.max(0, top) + "px";
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
