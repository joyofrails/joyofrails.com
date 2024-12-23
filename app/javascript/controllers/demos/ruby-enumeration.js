import { Controller } from '@hotwired/stimulus';

import { debug } from '../../utils';
import { isDarkMode } from '../darkmode';

const console = debug('app:javascript:controllers:demos:ruby-enumeration');

export default class extends Controller {
  static values = {
    url: String,
  };

  connect() {
    console.log('connect');

    const turboFrame = this.element;
    const url = new URL(this.urlValue);

    // Determine if the page is in Dark Mode
    url.searchParams.append('is_dark_mode', isDarkMode());

    console.log('url', url.toString());

    // Set the src attribute of the Turbo Frame element
    turboFrame.src = url.toString();
  }
}
