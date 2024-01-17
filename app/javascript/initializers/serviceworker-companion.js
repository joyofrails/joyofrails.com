import debug from 'debug';

const log = debug('app:javascript:initializers:serviceworker-companion');

log('Registering service worker...');
log('Vapid public key: ', window.config.vapid.publicKey);

if (navigator.serviceWorker) {
  navigator.serviceWorker
    .register('/serviceworker.js', { scope: './' })
    .then(function (reg) {
      log('Service worker registered!');
    });
}
