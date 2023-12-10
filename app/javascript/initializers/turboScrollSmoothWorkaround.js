import domReady from '../utils/domReady';

// If user has scrolled down the page, then navigates to a new page, Turbo will
// scroll back to the top of the page. We use this workaround to disable
// scroll-behavior: smooth on the <html> element before the visit, then
// re-enable it after the visit so that the smooth scroll won't run on Turbo
// visit. This won't affect users who haven't scrolled or who otherwise do not
// have scroll-behavior set.
export default async function () {
  await domReady();

  console.log('resetTurboScroll ready');
  document.querySelector('html').style.scrollBehavior;
  const scrollBehavior = document.querySelector('html').style.scrollBehavior;

  window.addEventListener('turbo:load', function () {
    console.log('turbo:load');
    document.querySelector('html').style.scrollBehavior = scrollBehavior;
  });
  window.addEventListener('turbo:before-visit', function () {
    console.log('turbo:before-visit');
    document.querySelector('html').style.scrollBehavior = 'unset';
  });
}
