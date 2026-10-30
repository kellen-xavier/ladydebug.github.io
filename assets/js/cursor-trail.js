(function () {
  "use strict";

  function createTrail(win, doc) {
    if (!win.matchMedia) return function () {};
    var motion = win.matchMedia("(prefers-reduced-motion: reduce)");
    var pointer = win.matchMedia("(any-pointer: fine)");
    var coarse = win.matchMedia("(any-pointer: coarse)");
    var particles = new Map();
    var last = null;

    function remove(particle) {
      win.clearTimeout(particles.get(particle));
      particles.delete(particle);
      particle.remove();
    }

    function clear() {
      particles.forEach(function (_, particle) { remove(particle); });
      last = null;
    }

    function move(event) {
      if (event.pointerType !== "mouse" || motion.matches || (coarse.matches && !pointer.matches) || doc.hidden) return;
      var now = win.performance.now();
      if (last) {
        var dx = event.clientX - last.x;
        var dy = event.clientY - last.y;
        if (now - last.time < 40 || dx * dx + dy * dy < 16) return;
      }
      last = { x: event.clientX, y: event.clientY, time: now };
      if (particles.size >= 12) remove(particles.keys().next().value);

      var particle = doc.createElement("span");
      particle.className = "cursor-sparkle";
      particle.setAttribute("aria-hidden", "true");
      particle.style.left = event.clientX + "px";
      particle.style.top = event.clientY + "px";
      particle.style.setProperty("--sparkle-x", (Math.random() - 0.5) * 20 + "px");
      particle.style.setProperty("--sparkle-y", 8 + Math.random() * 14 + "px");
      particle.style.setProperty("--sparkle-color", Math.random() < 0.5 ? "var(--ld-accent)" : "#d4b35f");
      doc.body.appendChild(particle);
      particles.set(particle, win.setTimeout(function () { remove(particle); }, 600));
    }

    doc.addEventListener("pointermove", move, { passive: true });
    doc.addEventListener("pointerleave", clear);
    doc.addEventListener("visibilitychange", clear);
    win.addEventListener("blur", clear);
    motion.addEventListener("change", clear);
    pointer.addEventListener("change", clear);
    coarse.addEventListener("change", clear);

    return function () {
      clear();
      doc.removeEventListener("pointermove", move);
      doc.removeEventListener("pointerleave", clear);
      doc.removeEventListener("visibilitychange", clear);
      win.removeEventListener("blur", clear);
      motion.removeEventListener("change", clear);
      pointer.removeEventListener("change", clear);
      coarse.removeEventListener("change", clear);
    };
  }

  if (typeof module !== "undefined" && module.exports) module.exports = { createTrail: createTrail };
  if (typeof window !== "undefined" && typeof document !== "undefined") createTrail(window, document);
})();
