import { Turbo } from '@hotwired/turbo-rails';
import { Controller } from '@hotwired/stimulus';

import { debug } from '../../utils';

const console = debug('app:javascript:controllers:snippets:tweet');

const WINDOW_OPTIONS = {
  width: 550,
  height: 420,
  toolbar: false,
  location: false,
  directories: false,
  status: false,
  menubar: false,
  scrollbars: true,
  copyhistory: false,
  resizable: true,
};

const WINDOW_OPTIONS_ARGUMENT = Object.entries(WINDOW_OPTIONS)
  .map(([key, value]) => `${key}=${value}`)
  .join(',');
export default class extends Controller<HTMLAnchorElement> {
  static values = {
    auto: Boolean,
    url: String,
  };

  declare readonly autoValue: boolean;
  declare readonly urlValue: string;

  connect() {
    console.log('Connect!');

    if (this.autoValue) {
      this.element.click();
      Turbo.visit(this.urlValue);
    }
  }

  tweet = (event: Event) => {
    if (event) {
      event.preventDefault();
    }

    const tweetUrl = (this.element as HTMLAnchorElement).href;

    window.open(tweetUrl, '_blank', WINDOW_OPTIONS_ARGUMENT);
  };
}
