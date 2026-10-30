const test = require('node:test');
const assert = require('node:assert/strict');
const calendar = require('../assets/js/calendar.js');

test('February includes leap day only in a leap year', () => {
  assert.equal(calendar.monthCells(2024, 1).filter(Boolean).length, 29);
  assert.equal(calendar.monthCells(2025, 1).filter(Boolean).length, 28);
});

test('month cells align weekdays and complete the final week', () => {
  const cells = calendar.monthCells(2026, 9);
  assert.deepEqual(cells.slice(0, 4), [null, null, null, null]);
  assert.equal(cells[4], '2026-10-01');
  assert.equal(cells.filter(Boolean).at(-1), '2026-10-31');
  assert.equal(cells.length % 7, 0);
  assert.equal(new Set(cells.filter(Boolean)).size, 31);
});

test('a month beginning on Sunday has no leading empty week', () => {
  assert.equal(calendar.monthCells(2026, 1)[0], '2026-02-01');
  assert.equal(calendar.monthCells(2026, 1).length, 28);
});

test('month navigation crosses years in both directions', () => {
  assert.deepEqual(calendar.moveMonth(2026, 11, 1), { year: 2027, month: 0 });
  assert.deepEqual(calendar.moveMonth(2026, 0, -1), { year: 2025, month: 11 });
});

test('today uses the visitor local date rather than its UTC date', () => {
  assert.equal(calendar.dateKey(new Date(2026, 9, 29, 23, 30)), '2026-10-29');
});

test('selecting a date returns all its events and no events from other days', () => {
  const events = [
    { date: '2026-10-29', title: 'First event' },
    { date: '2026-10-30', title: 'Tomorrow' },
    { date: '2026-10-29', title: 'Second event' },
  ];
  assert.deepEqual(calendar.eventsOn(events, '2026-10-29').map(event => event.title), ['First event', 'Second event']);
  assert.deepEqual(calendar.eventsOn(events, '2026-11-01'), []);
});

test('date labels support Portuguese and English without shifting the day', () => {
  assert.match(calendar.formatDay('2026-10-29', 'pt-BR'), /29.*outubro.*2026/);
  assert.match(calendar.formatDay('2026-10-29', 'en-US'), /October 29, 2026/);
});

test('event links accept web URLs but reject executable or malformed URLs', () => {
  const base = 'https://ladydebug.com.br/';
  assert.equal(calendar.eventHref('/about/', base), base + 'about/');
  assert.equal(calendar.eventHref('https://example.com/event', base), 'https://example.com/event');
  assert.equal(calendar.eventHref('javascript:alert(1)', base), null);
  assert.equal(calendar.eventHref('data:text/html,test', base), null);
  assert.equal(calendar.eventHref('http://[', base), null);
  assert.equal(calendar.eventHref('', base), null);
});
