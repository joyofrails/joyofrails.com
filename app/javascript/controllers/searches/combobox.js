import { Controller } from '@hotwired/stimulus';

import { debug } from '../../utils';

const console = debug('app:javascript:controllers:searches:combobox');

const cancel = (event) => {
  event.stopPropagation();
  event.preventDefault();
};

function cyclingValueAt(array, index) {
  const first = 0;
  const last = array.length - 1;

  if (index < first) return array[last];
  if (index > last) return array[first];
  return array[index];
}

export default class extends Controller {
  connect() {
    console.log('Connected', this.element, this.listbox, this.combobox);
  }

  selectIndex(index) {
    if (this.options.length === 0) return;

    console.log('Selecting index', index);

    const option = cyclingValueAt(this.options, index);

    this.select(option);
  }

  select(option) {
    console.log('Selecting', option.id);

    this.options.forEach(this.deselect.bind(this));

    option.classList.add('selected');
    option.setAttribute('aria-selected', 'true');
    this.setActiveDescendant(option.id);
  }

  deselect(option) {
    option.classList.remove('selected');
    option.removeAttribute('aria-selected');
    this.setActiveDescendant('');
  }

  setActiveDescendant(id) {
    console.log('Setting active descendant', id);
    this.combobox.setAttribute('aria-activedescendant', id);
  }

  listboxOpen({ detail }) {
    console.log('Listbox open', this.options.length > 0);
    this.combobox.setAttribute('aria-expanded', this.options.length > 0);
  }

  navigate(event) {
    console.log('Navigating', event); // event.key, e.g. "ArrowDown"
    this.navigationKeyHandlers[event.key]?.call(this, event);
  }

  get options() {
    return [...this.element.querySelectorAll('[role="option"]')];
  }

  get selectedItem() {
    return this.element.querySelector('.selected');
  }

  get selectedItemIndex() {
    return this.options.indexOf(this.selectedItem);
  }

  get combobox() {
    return this.element.querySelector('[role="combobox"]');
  }

  get listbox() {
    return this.element.querySelector('[role="listbox"]');
  }

  get navigationKeyHandlers() {
    return {
      ArrowDown: (event) => {
        this.selectIndex(this.selectedItemIndex + 1);
        cancel(event);
      },
      ArrowUp: (event) => {
        this.selectIndex(this.selectedItemIndex - 1);
        cancel(event);
      },
      Home: (event) => {
        this.selectIndex(0);
        cancel(event);
      },
      End: (event) => {
        this.selectIndex(this.options.length - 1);
        cancel(event);
      },
      Enter: (event) => {
        this.selectedItem?.querySelector('a')?.click();
        cancel(event);
      },
    };
  }
}
