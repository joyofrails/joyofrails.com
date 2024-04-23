import { Controller } from '@hotwired/stimulus';
import debug from '../utils/debug';

const console = debug('app:javascript:controllers:clipboard-copy');

export default class extends Controller {
  static targets = ['source'];

  connect() {
    console.log('connect');
  }

  copy() {
    console.log('copy', this.sourceTarget.dataset.value);
    navigator.clipboard.writeText(this.sourceTarget.dataset.value);

    this.timeout = setTimeout(() => {
      this.sourceTarget.blur();
      clearTimeout(this.timeout);
      this.timeout = null;
    }, 2000);
  }

  disconnect() {
    console.log('disconnect');
    if (this.timeout) {
      clearTimeout(this.timeout);
    }
  }
}
