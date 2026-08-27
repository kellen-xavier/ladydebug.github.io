(function () {
  var STORAGE_KEY = "ladydebug:view";
  var list = document.getElementById("ld-post-list");
  var buttons = document.querySelectorAll("[data-view-btn]");
  if (!list || !buttons.length) return;

  function setView(view) {
    list.setAttribute("data-view", view);
    buttons.forEach(function (btn) {
      var active = btn.getAttribute("data-view-btn") === view;
      btn.setAttribute("aria-pressed", active ? "true" : "false");
    });
    try {
      localStorage.setItem(STORAGE_KEY, view);
    } catch (e) {}
  }

  buttons.forEach(function (btn) {
    btn.addEventListener("click", function () {
      setView(btn.getAttribute("data-view-btn"));
    });
  });

  var saved;
  try {
    saved = localStorage.getItem(STORAGE_KEY);
  } catch (e) {}
  if (saved === "grid" || saved === "list") setView(saved);
})();
