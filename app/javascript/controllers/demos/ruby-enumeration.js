import { Controller } from '@hotwired/stimulus';

import { debug } from '../../utils';
import { isDarkMode } from '../darkmode';

const console = debug('app:javascript:controllers:demos:ruby-enumeration');

const cssThemeVariable = (prop) =>
  window.getComputedStyle(document.documentElement).getPropertyValue(prop);

export default class extends Controller {
  static values = {
    url: String,
  };

  connect() {
    console.log('connect');

    const iFrame = this.element;
    const url = new URL(this.urlValue || iFrame.src);

    if (isDarkMode()) {
      url.searchParams.append('isDarkMode', 'true');
    } else {
      url.searchParams.append(
        'background',
        cssThemeVariable('--joy-background'),
      );
    }

    url.searchParams.append(
      'gridLines',
      cssThemeVariable('--joy-border-subtle'),
    );

    url.searchParams.append('animationSpeed', 0.3);

    console.log('url', url.toString());

    iFrame.src = url.toString();
  }
}
