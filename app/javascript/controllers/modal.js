import { Controller } from '@hotwired/stimulus';

import { debug } from '../utils';

const console = debug('app:javascript:controllers:modal');

// Connects to data-controller="modal"
export default class extends Controller {
  connect() {
    console.log('Modal controller connected!');
  }

  show(event) {
    event.preventDefault();
    console.log('Show modal dialog: ', event.params);

    const dialog = document.getElementById(event.params.dialog);
    dialog.showModal();
  }
}
