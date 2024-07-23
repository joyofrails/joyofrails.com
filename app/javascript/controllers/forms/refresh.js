import { Controller } from '@hotwired/stimulus';
import debug from '../../utils/debug';

const console = debug('app:javascript:controllers:forms:refresh');

export default class extends Controller {
  connect() {
    console.log('connect');
  }

  refresh() {
    this.element.querySelectorAll('[required]').forEach((element) => {
      element.required = false;
    });
    const submitButton = document.createElement('input');
    submitButton.type = 'submit';
    submitButton.name = 'commit';
    submitButton.value = 'Refresh';
    submitButton.style.display = 'none';
    this.element.closest('form').appendChild(submitButton);
    submitButton.click();
  }
}
