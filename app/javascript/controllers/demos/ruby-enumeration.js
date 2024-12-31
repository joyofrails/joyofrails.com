import { Controller } from '@hotwired/stimulus';

import { debug } from '../../utils';
import { isDarkMode } from '../darkmode';

const console = debug('app:javascript:controllers:demos:ruby-enumeration');

const cssThemeVariable = (prop) =>
  window.getComputedStyle(document.documentElement).getPropertyValue(prop);

const setUrlPreferenceParams = (urlString) => {
  if (!urlString) {
    console.error('No URL provided');
    return 'http://example.com';
  }

  const url = new URL(urlString);

  if (isDarkMode()) {
    url.searchParams.append('isDarkMode', 'true');
    url.searchParams.delete('background');
  } else {
    url.searchParams.append('background', cssThemeVariable('--joy-background'));
    url.searchParams.delete('isDarkMode');
  }

  url.searchParams.append('gridLines', cssThemeVariable('--joy-border-subtle'));

  url.searchParams.append('animationSpeed', 0.3);

  return url.toString();
};

export default class extends Controller {
  static values = {
    url: String,
  };

  connect() {
    console.log('connect');
    this.element.onload = () => console.log('iframe loaded');

    // We expect this.element to be an iframe
    this.element.src = setUrlPreferenceParams(this.src);
  }

  darkmode({ detail: { mode } }) {
    console.log('changeDarkmode', mode);

    this.element.src = setUrlPreferenceParams(this.src);
  }

  get src() {
    return this.urlValue || this.element.src;
  }
}
