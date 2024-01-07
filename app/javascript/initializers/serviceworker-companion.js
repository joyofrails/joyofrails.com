import debug from 'debug';

const log = debug('app:javascript:initializers:serviceworker-companion');

if (navigator.serviceWorker) {
  navigator.serviceWorker
    .register('/serviceworker.js', { scope: './' })
    .then(function (reg) {
      log('Service worker registered!');
    });
}
