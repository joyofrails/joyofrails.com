import debug from 'debug';
import domReady from '../utils/domReady';

const log = debug('app:javascript:initializers:turbo-scroll-smooth-workaround');

// If user has scrolled down the page, then navigates to a new page, Turbo will
// scroll back to the top of the page. We use this workaround to disable
// scroll-behavior: smooth on the <html> element before the visit, then
// re-enable it after the visit so that the smooth scroll won't run on Turbo
// visit. This won't affect users who haven't scrolled or who otherwise do not
// have scroll-behavior set.
export default async function () {
  await domReady();

  document.querySelector('html').style.scrollBehavior;
  const scrollBehavior = document.querySelector('html').style.scrollBehavior;

  window.addEventListener('turbo:load', function () {
    log('turbo:load', 'reset scrollBehavior to', scrollBehavior);
    document.querySelector('html').style.scrollBehavior = scrollBehavior;
  });
  window.addEventListener('turbo:before-visit', function () {
    log('turbo:before-visit', 'set scrollBehavior to unset');
    document.querySelector('html').style.scrollBehavior = 'unset';
  });
}
