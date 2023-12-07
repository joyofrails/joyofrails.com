import { Controller } from 'stimulus';
import debug from 'debug';

const log = debug('darkmode');

export default class extends Controller {
  static targets = ['description', 'darkIcon', 'lightIcon'];

  connect() {
    log('Darkmode Controller connect');

    if (
      localStorage.getItem('color-theme') === 'dark' ||
      (!('color-theme' in localStorage) &&
        window.matchMedia('(prefers-color-scheme: dark)').matches)
    ) {
      this.darkIconTarget.classList.remove('hidden');
    } else {
      this.lightIconTarget.classList.remove('hidden');
    }
  }

  toggle() {
    log('Darkmode Controller toggle');

    // toggle icons inside button
    this.darkIconTarget.classList.toggle('hidden');
    this.lightIconTarget.classList.toggle('hidden');

    // if set via local storage previously
    if (localStorage.getItem('color-theme')) {
      if (localStorage.getItem('color-theme') === 'light') {
        this.setDark();
      } else {
        this.setLight();
      }

      // if NOT set via local storage previously
    } else {
      if (document.documentElement.classList.contains('dark')) {
        this.setLight();
      } else {
        this.setDark();
      }
    }
  }

  setDark() {
    log('Set Dark');
    document.documentElement.classList.add('dark');
    document.documentElement.classList.remove('light');
    localStorage.setItem('color-theme', 'dark');
    this.setDescription('Dark Mode');
  }

  setLight() {
    log('Set Light');
    document.documentElement.classList.remove('dark');
    document.documentElement.classList.add('light');
    localStorage.setItem('color-theme', 'light');
    this.setDescription('Light Mode');
  }

  setDescription(text) {
    const node = document.createTextNode(text);
    this.descriptionTarget.replaceChildren(node);
    log('Set Description', this.descriptionTarget.innerHTML);
  }
}
