import { Controller } from '@hotwired/stimulus';
import debug from '../../utils/debug';

const console = debug('app:javascript:controllers:syntax-highlight:preview');

export default class extends Controller {
  static values = {
    name: String,
  };

  connect() {
    console.log('connect', this.nameValue);
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
