import { Controller } from 'stimulus';
import debug from 'debug';

const log = debug('app:javascript:controllers:darkmode');

const controllers = new Set();

const broadcastDark = () => {
  controllers.forEach((controller) => controller.handleDark());
};

const broadcastLight = () => {
  controllers.forEach((controller) => controller.handleLight());
};
export default class extends Controller {
  static targets = ['description', 'darkIcon', 'lightIcon'];

  connect() {
    controllers.add(this);
    log('Darkmode Controller connect');

    if (this.hasStoredTheme('dark') || this.prefersColorTheme('dark')) {
      this.setDark();
    } else {
      this.setLight();
    }
  }

  disconnect() {
    controllers.delete(this);
    log('Darkmode Controller disconnect');
  }

  toggle() {
    log('Darkmode Controller toggle');

    if (this.hasStoredTheme('dark') || this.hasRenderedTheme('dark')) {
      broadcastLight();
    } else {
      broadcastDark();
    }
  }

  handleLight() {
    this.setLight();
    this.storeTheme('light');
  }

  handleDark() {
    this.setDark();
    this.storeTheme('dark');
  }

  hasStoredTheme(theme) {
    return localStorage.getItem('color-theme') === theme;
  }

  hasRenderedTheme(theme) {
    return document.documentElement.classList.contains(theme);
  }

  prefersColorTheme(theme) {
    return window.matchMedia(`(prefers-color-scheme: ${theme})`).matches;
  }

  setDark() {
    log('Set Dark');
    this.darkIconTarget.classList.remove('hidden');
    this.lightIconTarget.classList.add('hidden');
    document.documentElement.classList.add('dark');
    this.setDescription('Dark Mode');
  }

  storeTheme(theme) {
    localStorage.setItem('color-theme', theme);
  }

  setLight() {
    log('Set Light');
    this.darkIconTarget.classList.add('hidden');
    this.lightIconTarget.classList.remove('hidden');
    document.documentElement.classList.remove('dark');
    localStorage.setItem('color-theme', 'light');
    this.setDescription('Light Mode');
  }

  setDescription(text) {
    const node = document.createTextNode(text);
    this.descriptionTarget.replaceChildren(node);
    log('Set Description', this.descriptionTarget.innerHTML);
  }
}
