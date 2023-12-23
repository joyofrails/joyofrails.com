import { Controller } from 'stimulus';
import debug from 'debug';

const log = debug('app:javascript:controllers:darkmode');

const controllers = new Set();

const DARK = 'dark';
const LIGHT = 'light';
const SYSTEM = 'system';

const broadcastDark = () => {
  document.documentElement.classList.add(DARK);
  document.documentElement.classList.remove(LIGHT);
  controllers.forEach((controller) => controller.setDark());
};

const broadcastLight = () => {
  document.documentElement.classList.remove(DARK);
  document.documentElement.classList.add(LIGHT);

  controllers.forEach((controller) => controller.setLight());
};

const broadcastSystem = (color) => {
  document.documentElement.classList.add(color);
  document.documentElement.classList.remove(color === DARK ? LIGHT : DARK);

  controllers.forEach((controller) => controller.setSystem(color));
};

const prefersColorTheme = (theme) => window.matchMedia(`(prefers-color-scheme: ${theme})`).matches;

const storedTheme = () => localStorage.getItem('color-theme');
const storeTheme = (theme) => localStorage.setItem('color-theme', theme);

const removeTheme = () => localStorage.removeItem('color-theme');
export default class extends Controller {
  static targets = ['description', 'darkIcon', 'lightIcon', 'systemIcon'];

  static modes = [DARK, LIGHT, SYSTEM];

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
    log('Darkmode Controller disconnect');
  }

  setMode(mode) {
    this.mode = mode;

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

  toggle() {
    const index = this.constructor.modes.indexOf(this.mode);
    if (index === -1) {
      throw new Error(`Unknown mode ${this.mode}`);
    }
    if (index >= this.constructor.modes.length - 1) {
      this.setMode(this.constructor.modes[0]);
    } else {
      this.setMode(this.constructor.modes[index + 1]);
    }
  }

  setDark() {
    log('Set Dark');
    this.darkIconTarget.classList.remove('hidden');
    this.lightIconTarget.classList.add('hidden');
    this.systemIconTarget.classList.add('hidden');
    this.setDescription('Dark Mode');
  }

  setLight() {
    log('Set Light');
    this.darkIconTarget.classList.add('hidden');
    this.lightIconTarget.classList.remove('hidden');
    this.systemIconTarget.classList.add('hidden');
    this.setDescription('Light Mode');
  }

  setSystem() {
    log('Set System');
    this.darkIconTarget.classList.add('hidden');
    this.lightIconTarget.classList.add('hidden');
    this.systemIconTarget.classList.remove('hidden');
    this.setDescription('System Mode');
  }

  setDescription(text) {
    const node = document.createTextNode(text);
    this.descriptionTarget.replaceChildren(node);
    log('Set Description', this.descriptionTarget.innerHTML);
  }
}
