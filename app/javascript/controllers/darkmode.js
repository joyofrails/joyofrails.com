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
      this.lightIconTarget.classList.remove('hidden');
    } else {
      this.darkIconTarget.classList.remove('hidden');
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
    document.documentElement.classList.add('dark');
    localStorage.setItem('color-theme', 'dark');
    this.descriptionTarget.innerText = 'Dark Mode';
  }

  setLight() {
    document.documentElement.classList.remove('dark');
    localStorage.setItem('color-theme', 'light');
    this.descriptionTarget.innerText = 'Light Mode';
  }
}
