import { Controller } from '@hotwired/stimulus';

import { debug } from '../../utils';
import { isDarkMode } from '../darkmode';

const console = debug('app:javascript:controllers:demos:ruby-enumeration');

const cssThemeVariable = (prop) =>
  window.getComputedStyle(document.documentElement).getPropertyValue(prop);

export default class extends Controller {
  connect() {
    console.log('connect');

    // We expect this.element to be an iframe
    const url = new URL(this.element.src);

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

    this.element.src = url.toString();
  }

  darkmode({ detail: { mode } }) {
    console.log('changeDarkmode', mode);
    const url = new URL(this.element.src);

    if (mode === 'dark') {
      url.searchParams.append('isDarkMode', 'true');
      url.searchParams.delete('background');
    } else {
      url.searchParams.append(
        'background',
        cssThemeVariable('--joy-background'),
      );
      url.searchParams.delete('isDarkMode');
    }
    this.element.src = url.toString();
  }
}
