import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static values = {
    name: String, // The name of the syntax highlight css file to enable
  };

  connect() {
    const name = this.nameValue;
    document
      .querySelectorAll('link[rel="stylesheet"][data-syntax-highlight]')
      .forEach((link) => {
        console.log('link', link, {
          disabling: name !== link.dataset.syntaxHighlight,
        });
        link.disabled = name !== link.dataset.syntaxHighlight;
      });
  }
}
