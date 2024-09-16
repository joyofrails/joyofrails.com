import { Controller } from '@hotwired/stimulus';
import { debug, plausible } from '../../utils';

const console = debug('app:javascript:controllers:analytics:custom-event');

export default class extends Controller {
  static values = {
    event: String,
  };

  send() {
    console.log('send', this.eventValue);
    plausible(this.eventValue);
  }
}
