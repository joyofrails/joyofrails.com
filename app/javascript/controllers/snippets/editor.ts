import { Controller } from '@hotwired/stimulus';

import debug from '../../utils/debug';

const console = debug('app:javascript:controllers:snippets:editor');

export default class extends Controller {
  static targets = ['previewButton', 'source', 'textarea'];

  declare previewButtonTarget: HTMLButtonElement;
  declare sourceTarget: HTMLElement;
  declare textareaTarget: HTMLTextAreaElement;

  connect() {
    console.log('Stimulus controller connected');
    this.showCode();
    this.syncTextarea();
    // this.textareaTarget.addEventListener('input', this.autoGrow.bind(this));
    // this.textareaTarget.addEventListener(
    //   'blur',
    //   this.handleTextareaBlur.bind(this),
    // );
  }

  disconnect() {
    // this.textareaTarget.removeEventListener('input', this.autoGrow.bind(this));
    // this.textareaTarget.removeEventListener(
    //   'blur',
    //   this.handleTextareaBlur.bind(this),
    // );
  }

  preview() {
    this.previewButtonTarget.click();
  }

  showTextarea() {
    this.sourceTarget.style.display = 'none';
    this.textareaTarget.style.display = 'block';
    this.textareaTarget.focus();
    this.autoGrow();
  }

  syncTextarea() {
    this.textareaTarget.value = this.sourceTarget.textContent || '';
    this.autoGrow();
  }

  showCode() {
    this.sourceTarget.style.display = 'block';
    this.textareaTarget.style.display = 'none';
  }

  autoGrow() {
    this.textareaTarget.style.height = 'auto';
    this.textareaTarget.style.height = this.textareaTarget.scrollHeight + 'px';
  }
}
