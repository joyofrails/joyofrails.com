import { Turbo } from '@hotwired/turbo-rails';
import { Controller } from '@hotwired/stimulus';

import debug from '../../utils/debug';

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
export default class extends Controller {
  static values = {
    url: String,
    auto: Boolean,
  };

  declare urlValue: string;
  declare autoValue: boolean;

  connect() {
    console.log('Connect!');

    if (this.autoValue) {
      this.tweet();
      Turbo.visit(this.urlValue);
    }
  }

  tweet() {
    console.log('Tweet!');

    const url = this.urlValue;

    const tweetText = encodeURIComponent(`Created with @joyofrails ${url}`);

    const tweetUrl = `https://x.com/intent/post?text=${tweetText}`;

    window.open(tweetUrl, '_blank', WINDOW_OPTIONS_ARGUMENT);
  }
}
