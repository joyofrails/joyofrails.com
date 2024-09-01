import { Controller } from '@hotwired/stimulus';

import debug from '../../utils/debug';

const console = debug('app:javascript:controllers:snippets:tweet');

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
    }
  }

  tweet() {
    console.log('Tweet!');

    const url = this.urlValue;

    const tweetText = encodeURIComponent(`Created with @joyofrails ${url}`);

    const tweetUrl = `https://twitter.com/intent/tweet?text=${tweetText}`;

    window.open(
      tweetUrl,
      '_blank',
      'width=550,height=420,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,copyhistory=no,resizable=yes',
    );
  }
}
