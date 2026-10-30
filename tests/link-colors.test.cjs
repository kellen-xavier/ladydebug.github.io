const test = require('node:test');
const assert = require('node:assert/strict');
const { readFileSync } = require('node:fs');
const { join } = require('node:path');

const css = readFileSync(join(__dirname, '../assets/css/custom.css'), 'utf8');
const palette = selector => css.match(new RegExp(`${selector}\\s*\\{([^}]+)\\}`))[1];
const root = palette(':root');
const accent = root.match(/--ld-accent:\s*#([\da-f]{6})/i)[1];
const [red, green, blue] = accent.match(/../g).map(value => parseInt(value, 16) / 255);
const maximum = Math.max(red, green, blue);
const delta = maximum - Math.min(red, green, blue);
const accentHue = ((maximum === red ? (green - blue) / delta
  : maximum === green ? (blue - red) / delta + 2 : (red - green) / delta + 4) * 60 + 360) % 360;

for (const [name, selector] of [['light', ':root'], ['dark', '\\.dark']]) {
  test(`${name} theme link palette belongs to the existing blog accent color family`, () => {
    const hue = Number(palette(selector).match(/--primary-hue:\s*([\d.]+)deg/)[1]);
    const difference = Math.abs(hue - accentHue);
    assert.ok(Math.min(difference, 360 - difference) < 1,
      `${name} links use hue ${hue}°, but the blog accent uses ${accentHue.toFixed(1)}°`);
  });
}
