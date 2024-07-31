import { Controller } from '@hotwired/stimulus';

import debug from '../../utils/debug';

const console = debug('app:javascript:controllers:syntax-highlight:preview');

let submitting = false;

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

    if (submitting) {
      this.selectTarget.focus();
      submitting = false;
    }
  }

  change(event) {
    if (event.target.form) {
      event.target.form.requestSubmit();

      // This is some hacky module state so that we can retain the focus on the re-rendered select element after a submit
      submitting = true;
    }
  }
}
