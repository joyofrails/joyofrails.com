import { Controller } from '@hotwired/stimulus';

import { debounce } from '../../utils/debounce';
import debug from '../../utils/debug';

const console = debug('app:javascript:controllers:snippets:editor');

export default class extends Controller {
  static targets = ['previewButton', 'source', 'textarea'];

  declare previewButtonTarget: HTMLButtonElement;
  declare sourceTarget: HTMLElement;
  declare textareaTarget: HTMLTextAreaElement;

  declare onResize: EventListenerOrEventListenerObject;
  declare resizeDebounceDelayValue: number;

  static values = {
    resizeDebounceDelay: {
      type: Number,
      default: 100,
    },
  };

  connect() {
    console.log('Stimulus controller connected');

    this.disableEditMode();

    this.textareaTarget.style.overflow = 'hidden';
    const delay: number = this.resizeDebounceDelayValue;

    this.onResize = delay > 0 ? debounce(this.autogrow, delay) : this.autogrow;

    this.autogrow();

    this.element.addEventListener('click', this.enableEditMode);

    this.textareaTarget.addEventListener('blur', this.preview);
    this.textareaTarget.addEventListener('input', this.autogrow);
    window.addEventListener('resize', this.onResize);
  }

  disconnect() {
    window.removeEventListener('resize', this.onResize);
  }

  enableEditMode = () => {
    this.textareaTarget.disabled = false;
    this.textareaTarget.style.visibility = 'visible';
    this.sourceTarget.style.visibility = 'hidden';
  };

  disableEditMode = () => {
    this.textareaTarget.style.visibility = 'hidden';
    this.sourceTarget.style.visibility = 'visible';
  };

  autogrow = () => {
    if (this.textareaTarget.parentNode instanceof HTMLElement) {
      this.textareaTarget.parentNode.dataset.replicatedValue =
        this.textareaTarget.value;
    }
  };

  preview = () => {
    this.dispatch('changed', {
      detail: { content: this.textareaTarget.value },
    });
  };
}
