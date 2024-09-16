import { Controller } from '@hotwired/stimulus';

import { debounce } from '../../utils/debounce';
import { debug } from '../../utils';

const console = debug('app:javascript:controllers:snippets:editor');

export default class extends Controller {
  static targets = ['source', 'textarea'];

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
    console.log('Connect!');

    this.disableEditMode();

    this.textareaTarget.style.overflow = 'hidden';
    const delay: number = this.resizeDebounceDelayValue;

    this.onResize = delay > 0 ? debounce(this.autogrow, delay) : this.autogrow;

    this.autogrow();

    this.element.addEventListener('click', this.enableEditMode);

    this.textareaTarget.addEventListener('blur', this.finishedEditing);
    this.textareaTarget.addEventListener('input', this.autogrow);
    window.addEventListener('resize', this.onResize);
    window.addEventListener('click', this.checkIfFinishedEditing);
  }

  disconnect() {
    window.removeEventListener('resize', this.onResize);
    window.removeEventListener('click', this.checkIfFinishedEditing);
  }

  enableEditMode = () => {
    this.textareaTarget.disabled = false;
    this.textareaTarget.style.visibility = 'visible';
    this.sourceTarget.style.visibility = 'hidden';
    this.textareaTarget.focus();

    this.startedEditing();
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

  startedEditing = () => {
    console.log('Started editing!');
    this.dispatch('edit-start');
  };

  finishedEditing = () => {
    console.log('Finished editing!');
    this.dispatch('edit-finish', {
      detail: { content: this.textareaTarget.value },
    });
  };

  checkIfFinishedEditing = (event: Event) => {
    if (document.activeElement !== this.textareaTarget) {
      return;
    }

    if (
      this.textareaTarget === event.target ||
      this.textareaTarget.contains(event.target as Node) ||
      this.textareaTarget.parentNode === event.target
    ) {
      return;
    }

    this.finishedEditing();
  };
}
