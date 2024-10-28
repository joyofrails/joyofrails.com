import { Controller } from '@hotwired/stimulus';

import { debug } from '../utils';

const console = debug('app:javascript:controllers:modal-opener');

// Connects to data-controller="modal"
export default class extends Controller {
  connect() {
    console.log('Connect');
  }

  open(event) {
    event.preventDefault();
    console.log('Show modal dialog: ', event.params);

    const dialog = document.getElementById(event.params.dialog);
    dialog.showModal();
  }
}
