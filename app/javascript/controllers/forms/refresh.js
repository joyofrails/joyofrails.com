import { Controller } from '@hotwired/stimulus';
import debug from '../../utils/debug';

const console = debug('app:javascript:controllers:forms:refresh');

export default class extends Controller {
  static targets = ['refreshButton'];

  connect() {
    this.refreshButtonTarget.hidden = true;
  }

  refresh() {
    this.refreshButtonTarget.click();
  }
}
