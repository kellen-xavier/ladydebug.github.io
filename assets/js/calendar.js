(function () {
  "use strict";

  function pad(value) {
    return String(value).padStart(2, "0");
  }

  function dateKey(date) {
    return date.getFullYear() + "-" + pad(date.getMonth() + 1) + "-" + pad(date.getDate());
  }

  function monthCells(year, month) {
    var offset = new Date(Date.UTC(year, month, 1)).getUTCDay();
    var count = new Date(Date.UTC(year, month + 1, 0)).getUTCDate();
    var cells = Array(offset).fill(null);
    for (var day = 1; day <= count; day += 1) {
      cells.push(year + "-" + pad(month + 1) + "-" + pad(day));
    }
    while (cells.length % 7) cells.push(null);
    return cells;
  }

  function moveMonth(year, month, direction) {
    var date = new Date(Date.UTC(year, month + direction, 1));
    return { year: date.getUTCFullYear(), month: date.getUTCMonth() };
  }

  function eventsOn(events, day) {
    return events.filter(function (event) { return event.date === day; });
  }

  function formatDay(day, locale) {
    return new Intl.DateTimeFormat(locale, { dateStyle: "long", timeZone: "UTC" })
      .format(new Date(day + "T12:00:00Z"));
  }

  function eventHref(value, base) {
    if (!value) return null;
    try {
      var url = new URL(value, base);
      return /^(https?:)$/.test(url.protocol) ? url.href : null;
    } catch (_) {
      return null;
    }
  }

  if (typeof module !== "undefined" && module.exports) {
    module.exports = { monthCells: monthCells, moveMonth: moveMonth, dateKey: dateKey,
      eventsOn: eventsOn, formatDay: formatDay, eventHref: eventHref };
  }
  if (typeof document === "undefined") return;

  document.querySelectorAll("[data-calendar]").forEach(function (root) {
    var locale = root.dataset.locale;
    var events = JSON.parse(root.dataset.events);
    var now = new Date();
    var view = { year: now.getFullYear(), month: now.getMonth() };
    var selected = dateKey(now);
    var title = root.querySelector("[data-calendar-month]");
    var weekdays = root.querySelector("[data-calendar-weekdays]");
    var days = root.querySelector("[data-calendar-days]");
    var heading = root.querySelector("[data-calendar-selected]");
    var list = root.querySelector("[data-calendar-list]");

    for (var weekday = 0; weekday < 7; weekday += 1) {
      var cell = document.createElement("th");
      var date = new Date(Date.UTC(2023, 0, 1 + weekday));
      cell.scope = "col";
      cell.textContent = new Intl.DateTimeFormat(locale, { weekday: "short", timeZone: "UTC" }).format(date);
      cell.title = new Intl.DateTimeFormat(locale, { weekday: "long", timeZone: "UTC" }).format(date);
      weekdays.appendChild(cell);
    }

    function renderEvents() {
      heading.textContent = formatDay(selected, locale);
      list.replaceChildren();
      var matches = eventsOn(events, selected);
      if (!matches.length) {
        var empty = document.createElement("li");
        empty.className = "dock-window__empty";
        empty.textContent = root.dataset.empty;
        list.appendChild(empty);
      }
      matches.forEach(function (event) {
        var item = document.createElement("li");
        var href = eventHref(event.url, document.baseURI);
        var label = document.createElement(href ? "a" : "span");
        label.className = "dock-window__item-title";
        label.textContent = event.title;
        if (href) label.href = href;
        item.appendChild(label);
        list.appendChild(item);
      });
    }

    function render() {
      title.textContent = new Intl.DateTimeFormat(locale, { month: "long", year: "numeric", timeZone: "UTC" })
        .format(new Date(Date.UTC(view.year, view.month, 1)));
      days.replaceChildren();
      var row;
      var today = dateKey(new Date());
      monthCells(view.year, view.month).forEach(function (key, index) {
        if (index % 7 === 0) {
          row = document.createElement("tr");
          days.appendChild(row);
        }
        var cell = document.createElement("td");
        row.appendChild(cell);
        if (!key) return;
        var button = document.createElement("button");
        var count = eventsOn(events, key).length;
        button.type = "button";
        button.dataset.date = key;
        button.className = "dock-calendar__day" + (count ? " dock-calendar__day--event" : "");
        button.textContent = Number(key.slice(-2));
        button.setAttribute("aria-label", formatDay(key, locale) + (count ? ". " + root.dataset.eventsLabel + ": " + count : ""));
        button.setAttribute("aria-pressed", String(key === selected));
        if (key === today) button.setAttribute("aria-current", "date");
        cell.appendChild(button);
      });
      renderEvents();
    }

    root.addEventListener("click", function (event) {
      var button = event.target.closest("button");
      if (!button) return;
      var restoreDay = null;
      if (button.dataset.calendarMove) {
        view = moveMonth(view.year, view.month, Number(button.dataset.calendarMove));
        selected = view.year + "-" + pad(view.month + 1) + "-01";
      } else if (button.hasAttribute("data-calendar-today")) {
        var current = new Date();
        view = { year: current.getFullYear(), month: current.getMonth() };
        selected = dateKey(current);
      } else if (button.dataset.date) {
        selected = button.dataset.date;
        restoreDay = selected;
      } else {
        return;
      }
      render();
      if (restoreDay) days.querySelector('[data-date="' + restoreDay + '"]').focus();
    });

    render();
    root.hidden = false;
  });
})();
