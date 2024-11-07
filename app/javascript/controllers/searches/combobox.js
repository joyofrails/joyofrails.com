import { Controller } from '@hotwired/stimulus';

import { debug } from '../../utils';

const console = debug('app:javascript:controllers:searches:combobox');

const cancel = (event) => {
  event.stopPropagation();
  event.preventDefault();
};

/* When the index is out of bounds, return the first or last item */
function cyclingValueAt(array, index) {
  const first = 0;
  const last = array.length - 1;

  if (index < first) return array[last];
  if (index > last) return array[first];
  return array[index];
}

export default class extends Controller {
  static values = {
    expanded: Boolean,
  };

  connect() {
    console.log('Connected');

    this.tryOpen();
  }

  // Many Comboboxes act like fancy select inputs for forms. The Search Combobox
  // is currently hard-coded for for navigation: when an option is selected and
  // enabled with Enter key, we expect it to have a anchor tag and follow its link.
  go(event) {
    let anchor = this.selectedItem?.querySelector('a');

    if (anchor) {
      this.close();
      anchor.click();
    }
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

  expandedValueChanged() {
    console.log('Expanded value changed', this.expandedValue);
    if (this.expandedValue) {
      this.expand();
    } else {
      this.collapse();
    }
  }

  tryOpen() {
    if (this.options.length > 0) {
      this.open();
    } else {
      this.close();
    }
  }

  open() {
    this.expandedValue = true;
  }

  expand() {
    this.listbox.classList.remove('hidden');
    this.combobox.setAttribute('aria-expanded', true);
  }

  close() {
    this.expandedValue = false;
  }

  openInTarget(event) {
    if (!event.target) return;

    if (event.target.contains(this.element)) {
      this.tryOpen();
    }
  }

  closeInTarget(event) {
    if (!event.target) return;

    if (event.target.contains(this.element)) {
      this.close();
    }
  }

  collapse() {
    this.combobox.setAttribute('aria-expanded', false);
    this.listbox.classList.add('hidden');
  }

  closeAndBlur() {
    this.close();
    this.combobox.blur();
    this.dispatch('close');
  }

  get options() {
    return [...this.element.querySelectorAll('[role="option"]')];
  }

  get selectedItem() {
    return this.element.querySelector('[role="option"].selected');
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

  navigate(event) {
    this.navigationKeyHandlers[event.key]?.call(this, event);
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
        this.go(event);
        cancel(event);
      },
      Escape: (event) => {
        this.closeAndBlur();
        cancel(event); // Prevent ESC from clearing the search input as is the behavior in some browsers
      },
    };
  }
}
