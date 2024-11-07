import { Controller } from '@hotwired/stimulus';

import { debug } from '../../utils';

const console = debug('app:javascript:controllers:searches:listbox');

export default class extends Controller {
  connect() {
    console.log('Connected');

    this.dispatch('connected', { detail: { controller: this } });
  }
}
