import { Controller } from 'stimulus';
import debug from 'debug';

const log = debug('app:javascript:controllers:darkmode');

export default class extends Controller {
  static targets = ['description', 'darkIcon', 'lightIcon'];

  connect() {
    log('Darkmode Controller connect');

    if (this.hasStoredTheme('dark') || this.prefersColorTheme('dark')) {
      this.setDark();
    } else {
      this.setLight();
    }
  }

  toggle() {
    log('Darkmode Controller toggle');

    if (this.hasStoredTheme('dark') || this.hasRenderedTheme('dark')) {
      this.setLight();
      this.storeTheme('light');
    } else {
      this.setDark();
      this.storeTheme('dark');
    }
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
