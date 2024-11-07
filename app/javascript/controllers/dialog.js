import { Controller } from '@hotwired/stimulus';

import { debug } from '../utils';

const console = debug('app:javascript:controllers:search:dialog');

console.log('Loading search dialog controller');

const isEventClickInsideElement = (event, element) => {
  const rect = element.getBoundingClientRect();
  return (
    rect.top <= event.clientY &&
    event.clientY <= rect.top + rect.height &&
    rect.left <= event.clientX &&
    event.clientX <= rect.left + rect.width
  );
};

export default class extends Controller {
  connect() {
    console.log('Connected');
  }

  disconnect() {
    console.log('Disconnecting...');
  }

  isOpen() {
    return this.element.open;
  }

  open() {
    console.log('Opening dialog');
    this.element.showModal();
    this.dispatch('open');
  }

  close() {
    console.log('Closing dialog');
    this.element.close();
    this.dispatch('close');
  }

  tryClose(event) {
    const dialog = this.element;
    const clickIsOutsideDialog = !isEventClickInsideElement(event, dialog);

    if (clickIsOutsideDialog) {
      this.close();
    }
  }
}
