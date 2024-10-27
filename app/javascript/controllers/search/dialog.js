import { Controller } from '@hotwired/stimulus';

import { debug } from '../../utils';

const console = debug('app:javascript:controllers:search:dialog');

console.log('Loading search dialog controller');

export function isElementInViewport(el) {
  const rect = el.getBoundingClientRect();

  const windowHeight =
    window.innerHeight || document.documentElement.clientHeight;
  const windowWidth = window.innerWidth || document.documentElement.clientWidth;

  const vertInView = rect.top <= windowHeight && rect.top + rect.height > 0;
  const horInView = rect.left <= windowWidth && rect.left + rect.width > 0;

  return vertInView && horInView;
}

export default class extends Controller {
  connect() {
    console.log('Connected');
  }

  disconnect() {
    console.log('Disconnecting...');
    this.unobserve();
  }

  isOpen() {
    return this.element.open;
  }

  open() {
    console.log('Opening dialog');
    this.element.showModal();
  }

  close() {
    console.log('Closing dialog');
    this.element.close();
  }

  tryClose(event) {
    const dialog = this.element;
    const rect = dialog.getBoundingClientRect();
    const isInDialog =
      rect.top <= event.clientY &&
      event.clientY <= rect.top + rect.height &&
      rect.left <= event.clientX &&
      event.clientX <= rect.left + rect.width;

    console.log('Try to close dialog', isInDialog);

    if (!isInDialog) {
      this.close();
    }
  }
}
