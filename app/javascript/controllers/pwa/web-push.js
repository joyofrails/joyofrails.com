import { Controller } from '@hotwired/stimulus';
import debug from 'debug';

const log = debug('app:javascript:controllers:pwa-web-push');

const vapidPublicKey = window.config.vapid.publicKey;

const subscribe = async () => {
  if (!navigator.serviceWorker) {
    return Promise.resolve(false);
  }

  // When serviceWorker is supported, installed, and activated,
  // subscribe the pushManager property with the vapidPublicKey
  const registration = await navigator.serviceWorker.ready;

  log('registration ready', registration);
  let subscription = await registration.pushManager.getSubscription();

  if (subscription) {
    log('existing subscription', subscription);
  } else {
    subscription = registration.pushManager.subscribe({
      userVisibleOnly: true,
      applicationServerKey: vapidPublicKey,
    });

    if (subscription) {
      log('new subscription', subscription);
    } else {
      log('subscription failed');
    }
  }

  return subscription;
};

const unsubscribe = async () => {
  const subscription = await getSubscription();

  if (subscription) {
    // Unsubscribe if we have an existing subscription
    const result = await subscription.unsubscribe();
    log('unsubscribed?', result);
  } else {
    log('no subscription to unsubscribe');
  }
};

const getSubscription = async () => {
  const registration = await navigator.serviceWorker.ready;

  return await registration.pushManager.getSubscription();
};

export default class extends Controller {
  static targets = ['subscribeButton', 'unsubscribeButton'];

  async connect() {
    log('connect');

    if (!window.PushManager) {
      log('Push messaging is not supported in your browser');
      this.error = 'Push messaging is not supported in your browser';
    }

    if (!ServiceWorkerRegistration.prototype.showNotification) {
      log('Notifications are not supported in your browser');
      this.error = 'Notifications are not supported in your browser';
    }

    const subscription = await getSubscription();
    log('subscription', subscription);

    this.setPermission(Notification.permission);
    this.setSubscription(subscription);
  }

  setPermission(permission) {
    this.element.dataset.permission = permission;
  }

  async subscribe() {
    log('subscribe');
    let subscription;
    this.subscribeButtonTarget.disabled = true;

    if (Notification.permission !== 'granted') {
      const permission = await Notification.requestPermission();
      this.setPermission(permission);

      if (permission === 'granted') {
        log('Permission to receive notifications granted!');
        subscription = await subscribe();
      }
    } else {
      subscription = await subscribe();
    }

    this.subscribeButtonTarget.disabled = false;

    if (subscription) {
      this.setSubscription(subscription);
    } else {
      log('subscribe failed');
      this.error = 'Subscription failed';
    }
  }

  async unsubscribe() {
    log('unsubscribe');

    await unsubscribe();

    this.setSubscription(null);
  }

  async fetchSubscription() {
    log('register');

    const subscription = await subscribe();

    if (!subscription) {
      this.error = 'Subscription failed';
      return;
    }

    this.setSubscription(subscription);
  }

  setSubscription(subscription) {
    this.element.dataset.subscribed = !!subscription;
  }

  disconnect() {
    log('disconnect');
  }
}
