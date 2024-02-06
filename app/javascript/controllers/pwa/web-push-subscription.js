import { Controller } from '@hotwired/stimulus';
import debug from '../../utils/debug';

import {
  getSubscription,
  subscribe,
  unsubscribe,
  withPermission,
} from '../../utils/web-push';

const console = debug('app:javascript:controllers:pwa-web-push-subscription');

export default class extends Controller {
  static targets = ['subscribeButton', 'unsubscribeButton'];

  initialize() {
    console.log('initialize');
    this.error = null;
  }

  async connect() {
    console.log('connect');

    if (!window.PushManager) {
      this.setError('Push messaging is not supported in your browser');
    }

    if (!ServiceWorkerRegistration.prototype.showNotification) {
      this.setError('Notifications are not supported in your browser');
      console.error('Push messaging is not supported in your browser');
    }

    const subscription = await getSubscription();

    this.setSubscription(subscription);
  }

  async subscribe() {
    console.log('subscribe');
    this.setError(null);
    this.subscribeButtonTarget.disabled = true;

    try {
      await withPermission();

      const subscription = await subscribe();

      this.setSubscription(subscription);
    } catch (error) {
      this.setError(error);
      this.subscribeButtonTarget.disabled = false;
    }
  }

  async unsubscribe() {
    console.log('unsubscribe', 'start');

    const result = await unsubscribe();

    console.log('unsubscribe', result);

    this.setSubscription(null);
  }

  setSubscription(subscription) {
    console.log('setSubscription', subscription ? subscription.toJSON() : null);

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
    console.error('setError', error);
    this.dispatch('subscription-error', { detail: { error } });
  }

  disconnect() {
    console.log('disconnect');
  }
}
