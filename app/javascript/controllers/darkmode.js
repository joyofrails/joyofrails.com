import { Controller } from '@hotwired/stimulus';
import debug from '../utils/debug';

const console = debug('app:javascript:controllers:darkmode');

const controllers = new Set();

const DARK = 'dark';
const LIGHT = 'light';
const SYSTEM = 'system';

const modes = [DARK, LIGHT, SYSTEM];
let mode = SYSTEM;

const broadcastDark = () => {
  mode = DARK;
  document.documentElement.classList.add(DARK);
  document.documentElement.classList.remove(LIGHT);

  controllers.forEach((controller) => controller.setDark());
};

const broadcastLight = () => {
  mode = LIGHT;
  document.documentElement.classList.remove(DARK);
  document.documentElement.classList.add(LIGHT);

  controllers.forEach((controller) => controller.setLight());
};

const broadcastSystem = (color) => {
  mode = SYSTEM;
  document.documentElement.classList.add(color);
  document.documentElement.classList.remove(color === DARK ? LIGHT : DARK);

  controllers.forEach((controller) => controller.setSystem(color));
};

const prefersColorTheme = (theme) =>
  window.matchMedia(`(prefers-color-scheme: ${theme})`).matches;

const storedTheme = () => localStorage.getItem('color-theme');
const storeTheme = (theme) => localStorage.setItem('color-theme', theme);

const removeTheme = () => localStorage.removeItem('color-theme');

window
  .matchMedia(`(prefers-color-scheme: dark)`)
  .addEventListener('change', (e) => {
    if (mode !== SYSTEM) return;

    if (e.matches) {
      broadcastSystem(DARK);
    } else {
      broadcastSystem(LIGHT);
    }
  });

export default class extends Controller {
  static targets = ['description', 'darkIcon', 'lightIcon', 'systemIcon'];

  connect() {
    controllers.add(this);

    if (storedTheme()) {
      this.setMode(storedTheme());
    } else {
      this.setMode(SYSTEM);
    }
  }

  disconnect() {
    controllers.delete(this);
    console.log('Darkmode Controller disconnect');
  }

  setMode(mode) {
    switch (mode) {
      case DARK:
        broadcastDark();
        storeTheme(DARK);
        break;
      case LIGHT:
        broadcastLight();
        storeTheme(LIGHT);
        break;
      case SYSTEM:
        if (prefersColorTheme(DARK)) {
          broadcastSystem(DARK);
        } else {
          broadcastSystem(LIGHT);
        }
        removeTheme();
        break;
      default:
        throw new Error(`Unknown mode ${mode}`);
    }
  }

  cycle() {
    const index = modes.indexOf(mode);
    if (index === -1) {
      throw new Error(`Unknown mode ${mode}`);
    }

    const nextIndex = index >= modes.length - 1 ? 0 : index + 1;

    this.setMode(modes[nextIndex]);
  }

  setDark() {
    console.log('Set Dark');
    this.darkIconTarget.classList.remove('hidden');
    this.lightIconTarget.classList.add('hidden');
    this.systemIconTarget.classList.add('hidden');
    this.setDescription('Dark Mode');
  }

  setLight() {
    console.log('Set Light');
    this.darkIconTarget.classList.add('hidden');
    this.lightIconTarget.classList.remove('hidden');
    this.systemIconTarget.classList.add('hidden');
    this.setDescription('Light Mode');
  }

  setSystem() {
    console.log('Set System');
    this.darkIconTarget.classList.add('hidden');
    this.lightIconTarget.classList.add('hidden');
    this.systemIconTarget.classList.remove('hidden');
    this.setDescription('System Mode');
  }

  setDescription(text) {
    const node = document.createTextNode(text);
    this.descriptionTarget.replaceChildren(node);
    console.log('Set Description', this.descriptionTarget.innerHTML);
  }
}
