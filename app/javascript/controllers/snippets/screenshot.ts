import { Controller } from '@hotwired/stimulus';

import { debug } from '../../utils';

const console = debug('app:javascript:controllers:snippets:screenshot');

export default class extends Controller<HTMLFormElement> {
  static values = {
    auto: Boolean,
  };

  static targets = ['snippet', 'submitButton'];

  declare readonly snippetTarget: HTMLInputElement;
  declare readonly submitButtonTarget: HTMLInputElement;
  declare readonly autoValue: boolean;

  connect(): void {
    console.log('Connect!');

    this.element.addEventListener(
      'turbo:before-fetch-request',
      this.prepareScreenshot,
    );

    if (this.autoValue) {
      // submit immediately
      this.submitButtonTarget.click();
      this.submitButtonTarget.disabled = true;
    }
  }

  prepareScreenshot = async (event) => {
    event.preventDefault();

    if (event.detail.fetchOptions.body instanceof URLSearchParams) {
      console.log('Prepare screenshot!');

      const data = await this.drawScreenshot();

      event.detail.fetchOptions.body.append('screenshot', data);

      const searchParams = new URLSearchParams(window.location.search);
      ['auto', 'intent'].forEach((key) => {
        if (searchParams.get(key)) {
          event.detail.fetchOptions.body.append(key, searchParams.get(key));
        }
      });
    }

    event.detail.resume();
  };

  drawScreenshot = async () => {
    const htmlToImage = await import('html-to-image');

    return htmlToImage.toPng(this.snippetTarget);
  };
}
