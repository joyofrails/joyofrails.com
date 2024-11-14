import { Controller } from '@hotwired/stimulus';

import { debug } from '../utils';

const console = debug('app:javascript:controllers:current-page');

export default class extends Controller {
  connect() {
    console.log('Connected');

    this.updateActive();
    this.updateActive = this.updateActive.bind(this);

    window.addEventListener('turbo:before-render', this.updateActive);
    window.addEventListener('turbo:before-frame-render', this.updateActive);
  }

  disconnect() {
    window.removeEventListener('turbo:before-render', this.updateActive);
    window.removeEventListener('turbo:before-frame-render', this.updateActive);
  }

  updateActive(event) {
    console.log('updateActiveLink');
    this.element.querySelectorAll('a').forEach((link) => {
      if (link.getAttribute('href') === this.currentUrl) {
        link.classList.add('active');
        link.closest('li').classList.add('active');
      } else {
        link.classList.remove('active');
        link.closest('li').classList.remove('active');
      }
    });

    this.element.querySelectorAll('option').forEach((option) => {
      if (option.getAttribute('value') === this.currentUrl) {
        option.selected = true;
      }
    });
  }

  get currentUrl() {
    return window.location.pathname;
  }
}
