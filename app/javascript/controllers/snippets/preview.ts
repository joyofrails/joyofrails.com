import { Controller } from '@hotwired/stimulus';

import debug from '../../utils/debug';

const console = debug('app:javascript:controllers:snippets:preview');

export default class extends Controller {
  // Make timeout type play nice with TypeScript
  // based on https://donatstudios.com/TypeScriptTimeoutTrouble
  private idleTimeout?: ReturnType<typeof setTimeout>;

  static targets = ['previewButton'];

  declare readonly hasPreviewButtonTarget: boolean;
  declare readonly previewButtonTarget: HTMLInputElement;
  declare readonly previewButtonTargets: HTMLInputElement[];

  connect(): void {
    console.log('Connect!');
  }

  disconnect(): void {
    this.clearIdleTimeout();
  }

  clearIdleTimeout(): void {
    if (this.idleTimeout) clearTimeout(this.idleTimeout);
  }

  preview = (): void => {
    console.log('Start preview timer!');
    this.clearIdleTimeout();
    this.idleTimeout = setTimeout(this.clickPreviewButton, 500);
  };

  clickPreviewButton = (): void => {
    console.log('Click preview button!');
    this.previewButtonTarget.click();
  };
}
