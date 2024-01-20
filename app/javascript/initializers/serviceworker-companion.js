import debug from '../utils/debug';

const console = debug('app:javascript:initializers:serviceworker-companion');

console.log('Registering service worker...');
console.log('Web push key: ', window.config.webPushKey);

const registerServiceWorker = async () => {
  if (navigator.serviceWorker) {
    try {
      await navigator.serviceWorker.register('/serviceworker.js', {
        scope: './',
      });
      console.log('Service worker registered!');
    } catch (error) {
      console.log('Error registering service worker: ', error);
    }
  }
};

registerServiceWorker();
