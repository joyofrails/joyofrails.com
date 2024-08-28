import { Controller } from '@hotwired/stimulus';

import debug from '../../utils/debug';

const console = debug('app:javascript:controllers:snippets:preview');

export default class extends Controller<HTMLFormElement> {
  // Make timeout type play nice with TypeScript
  // based on https://donatstudios.com/TypeScriptTimeoutTrouble
  private idleTimeout?: ReturnType<typeof setTimeout>;

  static targets = ['previewButton'];

  declare readonly hasPreviewButtonTarget: boolean;
  declare readonly previewButtonTarget: HTMLInputElement;

  connect(): void {
    console.log('Connect!');

    this.element.addEventListener('turbo:submit-start', (event) => {
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
    });

    this.element.addEventListener('turbo:submit-end', (event) => {
      if (event.target instanceof HTMLFormElement) {
        for (const field of event.target.elements) {
          (field as HTMLInputElement).disabled = false;
        }
      }
    });
  }

  preview = (): void => {
    console.log('Start preview!');
    this.clickPreviewButton();
  };

  clickPreviewButton = (): void => {
    console.log('Click preview button!');
    this.previewButtonTarget.click();
  };
}
