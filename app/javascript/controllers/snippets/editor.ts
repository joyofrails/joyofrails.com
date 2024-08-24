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
    // this.textareaTarget.addEventListener('input', this.autoGrow.bind(this));
    // this.textareaTarget.addEventListener(
    //   'blur',
    //   this.handleTextareaBlur.bind(this),
    // );

    this.element.addEventListener('click', this.toggleEditMode.bind(this));
    this.textareaTarget.style.overflow = 'hidden';
    const delay: number = this.resizeDebounceDelayValue;

    // this.onResize = delay > 0 ? debounce(this.autogrow, delay) : this.autogrow;

    this.autogrow();

    // this.textareaTarget.addEventListener('input', this.autogrow);
    // window.addEventListener('resize', this.onResize);
  }

  disconnect() {
    // this.textareaTarget.removeEventListener('input', this.autoGrow.bind(this));
    // this.textareaTarget.removeEventListener(
    //   'blur',
    //   this.handleTextareaBlur.bind(this),
    // );
  }

  // sync() {
  //   this.sourceTarget.innerHTML = this.textareaTarget.value;
  //   this.textareaTarget.style.width = `${this.sourceTarget.offsetWidth}px`;
  // }

  toggleEditMode(event: Event) {
    this.textareaTarget.style.visibility = 'visible';
  }

  autogrow = () => {
    // Force re-print before calculating the value.
    // this.textareaTarget.style.height = 'auto';
    // this.textareaTarget.style.width = 'auto';

    if (this.textareaTarget.parentNode instanceof HTMLElement) {
      this.textareaTarget.parentNode.dataset.replicatedValue =
        this.textareaTarget.value;
    }

    // this.sourceTarget.innerHTML = this.textareaTarget.value + ' ';
    // this.textareaTarget.style.width = `${this.sourceTarget.scrollWidth}px`;

    // this.textareaTarget.style.height = `${this.textareaTarget.scrollHeight}px`;
  };

  preview() {
    this.previewButtonTarget.click();
  }
}
