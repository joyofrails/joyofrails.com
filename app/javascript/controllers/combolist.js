import { Controller } from '@hotwired/stimulus';

import { debug } from '../utils';

const console = debug('app:javascript:controllers:combolist');

const cancel = (event) => {
  event.stopPropagation();
  event.preventDefault();
};

export default class extends Controller {
  connect() {
    console.log('Connected');

    this.selectIndex(0);
  }

  selectIndex(index) {
    return this.items.forEach((item, i) => {
      item.classList.toggle('selected', i === index);
    });
  }

  navigate(event) {
    console.log('Navigating', event); // event.key, e.g. "ArrowDown"
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
        this.selectIndex(this.items.length - 1);
        cancel(event);
      },
      Enter: (event) => {
        this.selectedItem.click();
        cancel(event);
      },
    };
  }

  get items() {
    return [...this.element.querySelectorAll('a')];
  }

  get selectedItem() {
    return this.element.querySelector('.selected');
  }

  get selectedItemIndex() {
    return this.items.indexOf(this.selectedItem);
  }
}
