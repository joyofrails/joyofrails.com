import { Controller } from '@hotwired/stimulus';

import debug from '../../utils/debug';

const console = debug('app:javascript:controllers:snippets:tweet');

export default class extends Controller {
  static values = {
    url: String,
  };

  declare urlValue: string;

  connect() {
    console.log('Connect!');

    this.tweet();
  }

  tweet() {
    console.log('Tweet!');

    const tweetText = encodeURIComponent(this.urlValue);
    const tweetUrl = `https://twitter.com/intent/tweet?text=${tweetText}`;

    window.open(
      tweetUrl,
      '_blank',
      'width=550,height=420,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,copyhistory=no,resizable=yes',
    );
  }
}
