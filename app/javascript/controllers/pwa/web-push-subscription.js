import { Controller } from '@hotwired/stimulus';
import debug from 'debug';

import {
  getSubscription,
  subscribe,
  unsubscribe,
  withPermission,
} from '../../utils/web-push';

const log = debug('app:javascript:controllers:pwa-web-push-subscription');

export default class extends Controller {
  static targets = ['subscribeButton', 'unsubscribeButton'];

  initialize() {
    log('initialize');
    this.error = null;
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

    this.dispatch('subscription-changed', { detail: { subscription } });

    if (subscription) {
      this.subscribeButtonTarget.disabled = true;
      this.unsubscribeButtonTarget.disabled = false;
    } else {
      this.subscribeButtonTarget.disabled = false;
      this.unsubscribeButtonTarget.disabled = true;
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
