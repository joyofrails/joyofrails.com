import { Turbo } from '@hotwired/turbo-rails';
import { Controller } from '@hotwired/stimulus';

import { debug } from '../../utils';

const console = debug('app:javascript:controllers:forms:select-nav');

export default class extends Controller {
  static values = {
    turboFrame: String,
  };

  connect() {
    console.log('Connected');
  }

  visit(event) {
    const [selectedOption] = this.element.selectedOptions;
    const url = selectedOption.value;

    // Value is empty for blank option
    if (url === '') {
      return;
    }

    console.log('Visiting', url, event);

    const opts = {
      action: 'advance',
    };

    if (this.turboFrameValue) {
      opts.frame = this.turboFrameValue;
    }

    Turbo.visit(url, opts);
  }
}
