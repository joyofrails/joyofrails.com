import debug from 'debug';

const log = debug('app:javascript:initializers:serviceworker-companion');

log('Registering service worker...');
log('Web push key: ', window.config.webPushKey);

if (navigator.serviceWorker) {
  navigator.serviceWorker
    .register('/serviceworker.js', { scope: './' })
    .then((reg) => {
      log('Service worker registered!');
    });
}
