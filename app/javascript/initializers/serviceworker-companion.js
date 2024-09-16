import { debug } from '../utils';

const console = debug('app:javascript:initializers:serviceworker-companion');

console.log('Registering service worker...');
console.log('Web push key: ', window.config.webPushKey);

export default async () => {
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
