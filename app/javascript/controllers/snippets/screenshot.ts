import { Controller } from '@hotwired/stimulus';
import * as htmlToImage from 'html-to-image';

import debug from '../../utils/debug';

const console = debug('app:javascript:controllers:snippets:screenshot');

export default class extends Controller<HTMLFormElement> {
  static targets = ['snippet'];

  declare readonly hasSnippetTarget: boolean;
  declare readonly snippetTarget: HTMLInputElement;

  connect(): void {
    console.log('Connect!');

    this.element.addEventListener(
      'turbo:before-fetch-request',
      this.prepareScreenshot,
    );
  }

  prepareScreenshot = async (event) => {
    event.preventDefault();

    if (event.detail.fetchOptions.body instanceof URLSearchParams) {
      console.log('Prepare screenshot!');

      const data = await this.drawScreenshot();

      event.detail.fetchOptions.body.append('screenshot', data);
    }

    event.detail.resume();
  };

  drawScreenshot = async () => {
    return htmlToImage.toPng(this.snippetTarget);
  };
}