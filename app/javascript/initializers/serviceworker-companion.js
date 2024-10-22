import { debug } from '../utils';

const console = debug('app:javascript:initializers:serviceworker-companion');

console.log('Registering service worker...');

export default () => {
  if ('serviceWorker' in navigator) {
    window.addEventListener('load', async () => {
      try {
        await navigator.serviceWorker.register('/serviceworker.js', {
          scope: './',
        });
        console.log('Service worker now registered!');
      } catch (error) {
        console.log('Error registering service worker: ', error);
      }
    });
  }
};
