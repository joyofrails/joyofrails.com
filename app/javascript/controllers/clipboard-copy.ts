import { Controller } from '@hotwired/stimulus';
import debug from '../utils/debug';

const console = debug('app:javascript:controllers:clipboard-copy');

export default class extends Controller {
  static targets = ['source'];

  declare readonly sourceTarget: HTMLElement;
  declare timeout: number | null;

  connect() {
    console.log('connect');
  }

  copy(e: Event) {
    console.log('copy', this.sourceTarget.dataset.value);
    if (this.sourceTarget.dataset.value !== undefined) {
      navigator.clipboard.writeText(this.sourceTarget.dataset.value);
    }

    this.timeout = window.setTimeout(() => {
      this.sourceTarget.blur();
      this.cleanup();
    }, 2000);
  }

  disconnect() {
    console.log('disconnect');
    this.cleanup();
  }

  cleanup() {
    if (this.timeout) {
      window.clearTimeout(this.timeout);
      this.timeout = null;
    }
  }
}
