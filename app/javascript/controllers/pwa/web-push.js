import { Controller } from '@hotwired/stimulus';
import debug from 'debug';

const log = debug('app:javascript:controllers:pwa-web-push');

const webPushKey = window.config.webPushKey;

const subscribe = async () => {
  if (!navigator.serviceWorker) {
    return Promise.resolve(false);
  }

  // When serviceWorker is supported, installed, and activated,
  // subscribe the pushManager property with the webPushKey
  const registration = await navigator.serviceWorker.ready;

  log('registration ready', registration);
  let subscription = await registration.pushManager.getSubscription();

  if (subscription) {
    log('existing subscription', subscription);
  } else {
    subscription = registration.pushManager.subscribe({
      userVisibleOnly: true,
      applicationServerKey: Uint8Array.from(atob(webPushKey), (m) =>
        m.codePointAt(0),
      ),
    });

    if (!subscription) {
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
  static targets = ['subscribedGroup', 'unsubscribedGroup', 'subscription'];

  initialize() {
    log('initialize');
    this.error = null;
    this.subscription = null;
  }

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

    const permission = await Notification.requestPermission();
    this.setPermission(permission);

    if (Notification.permission !== 'granted') {
      log('Notification permission not granted!', permission);
      return;
    }
    const subscription = await subscribe();

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

  setSubscription(subscription) {
    log(
      'setSubscription',
      subscription,
      subscription ? subscription.toJSON() : null,
    );
    this.subscription = subscription;

    if (subscription) {
      this.subscriptionTarget.value = JSON.stringify(subscription);

      this.subscribedGroupTarget.classList.remove('hidden');
      this.unsubscribedGroupTarget.classList.add('hidden');
    } else {
      this.subscriptionTarget.value = '';

      this.subscribedGroupTarget.classList.add('hidden');
      this.unsubscribedGroupTarget.classList.remove('hidden');
    }
  }

  disconnect() {
    log('disconnect');
  }
}
