import { Controller } from 'stimulus';
import debug from 'debug';

import domReady from '../utils/dom-ready';

const log = debug('app:javascript:controllers:table-of-contents');

export default class extends Controller {
  async connect() {
    await domReady();
    const $el = this.element;
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          const id = entry.target.getAttribute('id');
          if (!id) return;

          const tocLink = $el.querySelector(`li a[href="#${id}"]`);
          if (!tocLink) return;

          if (entry.intersectionRatio > 0) {
            tocLink.classList.add('active');
          } else {
            tocLink.classList.remove('active');
          }
        });
      },
      {
        threshold: 1.0,
        rootMargin: '0px 0px -50%',
        // root: document.querySelector('article'),
        // 🆕 Track the actual visibility of the element
        trackVisibility: true,
        // 🆕 Set a minimum delay between notifications
        delay: 1000,
      },
    );

    // Track all sections that have an `id` applied
    document.querySelectorAll(':is(article) :is(h1, h2, h3, h4, h5, h6)').forEach((section) => {
      observer.observe(section);
    });
  }
}
