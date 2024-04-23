import { Controller } from '@hotwired/stimulus';
import debug from '../../utils/debug';

const console = debug('app:javascript:controllers:plausible:custom-event');

export default class extends Controller {
  static values = {
    event: String,
  };

  send() {
    console.log('send', this.eventValue);
    window.plausible(this.eventValue);
  }
}
