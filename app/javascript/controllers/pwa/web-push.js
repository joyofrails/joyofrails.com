import { Controller } from '@hotwired/stimulus';
import debug from 'debug';

const log = debug('app:javascript:controllers:pwa-web-push');

const webPushKey = window.config.webPushKey;

const withPermission = async () => {
  let permission = Notification.permission;
  if (permission === 'granted') {
    return permission;
  } else if (permission === 'denied') {
    throw new Error(`Permission for notifications is ${permission}`);
  } else {
    permission = await Notification.requestPermission();

    if (permission === 'granted') {
      return permission;
    } else {
      throw new Error(`Permission for notifications is ${permission}`);
    }
  }
};

const subscribe = async () => {
  if (!navigator.serviceWorker) {
    throw new Error('Service worker not supported');
  }

  // When serviceWorker is supported, installed, and activated,
  // subscribe the pushManager property with the webPushKey
  const registration = await navigator.serviceWorker.ready;

  let subscription = await registration.pushManager.getSubscription();

  if (!subscription) {
    subscription = registration.pushManager.subscribe({
      userVisibleOnly: true,
      applicationServerKey: Uint8Array.from(atob(webPushKey), (m) =>
        m.codePointAt(0),
      ),
    });

    if (!subscription) {
      throw new Error('Web push subscription failed');
    }
  }

  return subscription;
};

const unsubscribe = async () => {
  const subscription = await getSubscription();

  if (subscription) {
    // Unsubscribe if we have an existing subscription
    return await subscription.unsubscribe();
  } else {
    return false;
  }
};

const getSubscription = async () => {
  const registration = await navigator.serviceWorker.ready;

  return await registration.pushManager.getSubscription();
};

export default class extends Controller {
  static targets = [
    'subscribeButton',
    'unsubscribeButton',
    'sendPushDemoFieldset',
    'subscriptionField',
  ];

  initialize() {
    log('initialize');
    this.error = null;
    this.subscription = null;
  }

  async connect() {
    log('connect');

    if (!window.PushManager) {
      this.setError('Push messaging is not supported in your browser');
    }

    if (!ServiceWorkerRegistration.prototype.showNotification) {
      this.setError('Notifications are not supported in your browser');
    }

    const subscription = await getSubscription();

    this.setSubscription(subscription);
  }

  async subscribe() {
    log('subscribe');

    try {
      await withPermission();

      const subscription = await subscribe();

      this.setSubscription(subscription);
    } catch (error) {
      this.setError(error);
    }
  }

  async unsubscribe() {
    log('unsubscribe', 'start');

    const result = await unsubscribe();

    log('unsubscribe', result);

    this.setSubscription(null);
  }

  setSubscription(subscription) {
    log('setSubscription', subscription ? subscription.toJSON() : null);
    this.subscription = subscription;

    if (subscription) {
      this.subscriptionFieldTarget.value = JSON.stringify(subscription);

      this.subscribeButtonTarget.disabled = true;
      this.unsubscribeButtonTarget.disabled = false;
      this.sendPushDemoFieldsetTarget.disabled = false;
    } else {
      this.subscriptionFieldTarget.value = '';
      this.subscribeButtonTarget.disabled = false;
      this.unsubscribeButtonTarget.disabled = true;
      this.sendPushDemoFieldsetTarget.disabled = true;
    }
  }

  setError(error) {
    log('setError', error);
    this.error = error;
  }

  disconnect() {
    log('disconnect');
  }
}
