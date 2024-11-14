import { Controller } from '@hotwired/stimulus';

import { debug } from '../utils';

const console = debug('app:javascript:controllers:current-page');

export default class extends Controller {
  connect() {
    console.log('Connected');

    this.updateActiveLink();
    this.updateSelectedOption();
    this.updateActiveLink = this.updateActiveLink.bind(this);

    window.addEventListener('turbo:before-render', this.updateActiveLink);
    window.addEventListener('turbo:before-frame-render', this.updateActiveLink);
  }

  disconnect() {
    window.removeEventListener('turbo:before-render', this.updateActiveLink);
    window.removeEventListener(
      'turbo:before-frame-render',
      this.updateActiveLink,
    );
  }

  updateActiveLink(event) {
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
  }

  updateSelectedOption() {
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
