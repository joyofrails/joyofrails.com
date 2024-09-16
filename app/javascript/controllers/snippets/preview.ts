import { Controller } from '@hotwired/stimulus';

import { debug, debounce } from '../../utils';

const console = debug('app:javascript:controllers:snippets:preview');

export default class extends Controller<HTMLFormElement> {
  static targets = ['previewButton'];

  declare readonly hasPreviewButtonTarget: boolean;
  declare readonly previewButtonTarget: HTMLInputElement;

  connect(): void {
    console.log('Connect!');

    // this.element.addEventListener('turbo:submit-start', this.disable);
    // this.element.addEventListener('turbo:submit-end', this.enable);
  }

  disable = (event): void => {
    if (
      (event as CustomEvent).detail.formSubmission.submitter !==
      this.previewButtonTarget
    ) {
      return;
    }

    if (event.target instanceof HTMLFormElement) {
      for (const field of event.target.elements) {
        (field as HTMLInputElement).disabled = true;
      }
    }
  };

  enable = (event): void => {
    if (event.target instanceof HTMLFormElement) {
      for (const field of event.target.elements) {
        (field as HTMLInputElement).disabled = false;
      }
    }
  };

  preview = (): void => {
    console.log('Start preview!');

    // Click the preview button after 0 delay to submit in the next tick
    setTimeout(() => {
      this.clickPreviewButton();
    });
  };

  clickPreviewButton = (): void => {
    console.log('Click preview button!');
    this.previewButtonTarget.click();
  };
}
