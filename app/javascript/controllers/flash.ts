import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.dismiss();
    }, 5000);
  }

  dismiss() {
    (this.element as HTMLElement).style.opacity = '0';
    setTimeout(() => this.element.remove(), 1000);
  }
}
