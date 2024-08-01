import { Controller } from '@hotwired/stimulus';

import debug from '../../utils/debug';

const console = debug('app:javascript:controllers:syntax-highlight:preview');

export default class extends Controller {
  static values = {
    name: String, // The name of the syntax highlight css file to enable
  };

  static targets = ['select'];

  connect() {
    console.log('connect');

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

  change(event) {
    if (event.target.form) {
      event.target.form.requestSubmit();
    }
  }
}
