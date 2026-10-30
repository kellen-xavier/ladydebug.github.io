const test = require('node:test');
const assert = require('node:assert/strict');
const { createTrail } = require('../assets/js/cursor-trail.js');

function environment({ reducedMotion = false, finePointer = true, coarsePointer = !finePointer } = {}) {
  function target() {
    const listeners = new Map();
    return {
      addEventListener(type, callback) { listeners.set(type, callback); },
      removeEventListener(type) { listeners.delete(type); },
      dispatch(type, event = {}) { listeners.get(type)?.(event); },
      listenerCount() { return listeners.size; },
    };
  }
  let now = 0;
  let id = 0;
  const timers = new Map();
  const particles = [];
  const motion = Object.assign(target(), { matches: reducedMotion });
  const pointer = Object.assign(target(), { matches: finePointer });
  const coarse = Object.assign(target(), { matches: coarsePointer });
  const doc = Object.assign(target(), {
    hidden: false,
    body: { appendChild(particle) { particles.push(particle); } },
    createElement() {
      return {
        attributes: {},
        style: { setProperty(name, value) { this[name] = value; } },
        setAttribute(name, value) { this.attributes[name] = value; },
        remove() { const index = particles.indexOf(this); if (index !== -1) particles.splice(index, 1); },
      };
    },
  });
  const win = Object.assign(target(), {
    performance: { now: () => now },
    matchMedia: query => query.includes('reduced-motion') ? motion : query.includes('coarse') ? coarse : pointer,
    setTimeout(callback, delay) { timers.set(++id, { callback, due: now + delay }); return id; },
    clearTimeout(timer) { timers.delete(timer); },
  });
  return {
    win, doc, motion, pointer, coarse, particles, timers,
    move(x = 100, y = 200, pointerType = 'mouse') {
      doc.dispatch('pointermove', { clientX: x, clientY: y, pointerType });
    },
    advance(milliseconds) {
      now += milliseconds;
      for (const [key, timer] of timers) {
        if (timer.due <= now) { timers.delete(key); timer.callback(); }
      }
    },
  };
}

test('mouse movement creates a decorative sparkle at viewport coordinates', () => {
  const env = environment();
  createTrail(env.win, env.doc);
  env.move(125, 240);
  assert.equal(env.particles.length, 1);
  const particle = env.particles[0];
  assert.equal(particle.className, 'cursor-sparkle');
  assert.equal(particle.attributes['aria-hidden'], 'true');
  assert.equal(particle.style.left, '125px');
  assert.equal(particle.style.top, '240px');
});

test('touch and pen input do not create a trail', () => {
  const env = environment();
  createTrail(env.win, env.doc);
  env.move(10, 20, 'touch');
  env.move(30, 40, 'pen');
  assert.equal(env.particles.length, 0);
});

test('reduced-motion and touch-only devices do not emit particles', () => {
  for (const settings of [{ reducedMotion: true }, { finePointer: false }]) {
    const env = environment(settings);
    createTrail(env.win, env.doc);
    env.move();
    assert.equal(env.particles.length, 0);
    assert.equal(env.timers.size, 0);
  }
});

test('real mouse events work when the browser does not report pointer hardware', () => {
  const env = environment({ finePointer: false, coarsePointer: false });
  createTrail(env.win, env.doc);
  env.move();
  assert.equal(env.particles.length, 1);
});

test('rapid or stationary pointer events do not create excessive particles', () => {
  const env = environment();
  createTrail(env.win, env.doc);
  env.move();
  for (let i = 0; i < 50; i++) env.move(150 + i, 250);
  assert.equal(env.particles.length, 1);
  env.advance(50);
  env.move();
  assert.equal(env.particles.length, 1);
  env.move(200, 300);
  assert.equal(env.particles.length, 2);
});

test('particles stay bounded and are removed after a short lifetime', () => {
  const env = environment();
  createTrail(env.win, env.doc);
  for (let i = 0; i < 30; i++) {
    env.move(i * 10, 100);
    assert.ok(env.particles.length <= 12);
    env.advance(40);
  }
  assert.ok(env.particles.length > 0);
  env.advance(700);
  assert.equal(env.particles.length, 0);
  assert.equal(env.timers.size, 0);
});

test('changing motion preferences clears the trail immediately', () => {
  const env = environment();
  createTrail(env.win, env.doc);
  env.move();
  assert.equal(env.particles.length, 1);
  env.motion.matches = true;
  env.motion.dispatch('change');
  assert.equal(env.particles.length, 0);
  env.advance(50);
  env.move(200, 300);
  assert.equal(env.particles.length, 0);
});

test('leaving the page or hiding the tab clears all particles', () => {
  const env = environment();
  createTrail(env.win, env.doc);
  env.move();
  assert.equal(env.particles.length, 1);
  env.win.dispatch('blur');
  assert.equal(env.particles.length, 0);
  env.advance(50);
  env.move(200, 300);
  env.doc.hidden = true;
  env.doc.dispatch('visibilitychange');
  assert.equal(env.particles.length, 0);
  env.advance(50);
  env.move(250, 350);
  assert.equal(env.particles.length, 0);
});

test('destroy removes particles, timers, and input listeners', () => {
  const env = environment();
  const destroy = createTrail(env.win, env.doc);
  env.move();
  assert.equal(env.particles.length, 1);
  destroy();
  assert.equal(env.particles.length, 0);
  assert.equal(env.timers.size, 0);
  for (const target of [env.win, env.doc, env.motion, env.pointer, env.coarse]) {
    assert.equal(target.listenerCount(), 0);
  }
  env.advance(50);
  env.move(200, 300);
  assert.equal(env.particles.length, 0);
});
