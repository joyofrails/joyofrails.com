import { Controller } from '@hotwired/stimulus';

import { debug, debounce } from '../../utils';

const console = debug('app:javascript:controllers:forms:autosubmit');

export default class extends Controller {
  static values = {
    delay: {
      type: Number,
      default: 0,
    },
    mininumLength: {
      type: Number,
      default: 0,
    },
  };

  connect() {
    console.log('Connected');

    if (this.delayValue) {
      this.submit = debounce(this.submit.bind(this), this.delayValue);
    }
  }

  submit(event) {
    console.log('Submitting', event);

    if (!event.target.value) {
      this.element.requestSubmit();
      return;
    }

    if (event.target.value.length >= this.mininumLengthValue) {
      this.element.requestSubmit();
    } else {
      console.log(
        'Not submitting until',
        this.mininumLengthValue,
        'characters',
      );
    }
  }
}
