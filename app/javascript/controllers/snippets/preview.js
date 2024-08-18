import { Controller } from '@hotwired/stimulus';

import debug from '../../utils/debug';

const console = debug('app:javascript:controllers:snippets:preview');

export default class extends Controller {
  static targets = ['source', 'previewButton'];
  idleTimeout = null;

  connect() {
    console.log('Connect!');
    // this.sourceTarget.addEventListener('keydown', this.handleKeyDown);
  }

  disconnect() {
    // this.sourceTarget.removeEventListener('keydown', this.handleKeyDown);
    clearTimeout(this.idleTimeout);
  }

  preview = () => {
    console.log('Start preview timer!');
    clearTimeout(this.idleTimeout);
    this.idleTimeout = setTimeout(this.clickPreviewButton, 500);
  };

  // handleKeyDown = () => {
  //   clearTimeout(this.idleTimeout);
  //   this.idleTimeout = setTimeout(this.clickPreviewButton, 500);
  // };

  clickPreviewButton = () => {
    console.log('Click preview button!');
    this.previewButtonTarget.click();
  };
}
