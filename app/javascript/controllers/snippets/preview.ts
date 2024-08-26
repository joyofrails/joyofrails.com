import { Controller } from '@hotwired/stimulus';
import * as htmlToImage from 'html-to-image';

import debug from '../../utils/debug';

const console = debug('app:javascript:controllers:snippets:preview');

export default class extends Controller<HTMLFormElement> {
  // Make timeout type play nice with TypeScript
  // based on https://donatstudios.com/TypeScriptTimeoutTrouble
  private idleTimeout?: ReturnType<typeof setTimeout>;

  static targets = ['previewButton', 'snippet'];

  declare readonly hasPreviewButtonTarget: boolean;
  declare readonly previewButtonTarget: HTMLInputElement;
  declare readonly previewButtonTargets: HTMLInputElement[];

  declare readonly hasSnippetTarget: boolean;
  declare readonly snippetTarget: HTMLInputElement;
  declare readonly snippetTargets: HTMLInputElement[];

  connect(): void {
    console.log('Connect!');

    this.element.addEventListener(
      'turbo:before-fetch-request',
      this.prepareScreenshot,
    );
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

  share = async (event: CustomEvent) => {
    console.log('Share!');
    event.preventDefault();

    const data = await htmlToImage.toPng(this.snippetTarget);

    const input = document.createElement('input');
    input.type = 'hidden';
    input.name = 'snippet[screenshot]';
    input.value = data;

    this.element.requestSubmit();
  };

  prepareScreenshot = async (event) => {
    event.preventDefault();

    if (event.detail.fetchOptions.body instanceof URLSearchParams) {
      const data = await this.drawScreenshot();

      event.detail.fetchOptions.body.append('screenshot', data);
    }

    event.detail.resume();
  };

  drawScreenshot = async () => {
    return htmlToImage.toPng(this.snippetTarget);
  };
}
