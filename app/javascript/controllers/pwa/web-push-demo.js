import { Controller } from '@hotwired/stimulus';
import debug from 'debug';

const log = debug('app:javascript:controllers:pwa-web-push-demo');

export default class extends Controller {
  static targets = ['sendPushDemoFieldset', 'subscriptionField'];

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
  }

  onSubscriptionChanged({ detail: { subscription } }) {
    log('onSubscriptionChanged');
    this.setSubscription(subscription);
  }

  setSubscription(subscription) {
    log('setSubscription', subscription ? subscription.toJSON() : null);

    if (subscription) {
      this.subscriptionFieldTarget.value = JSON.stringify(subscription);
      this.sendPushDemoFieldsetTarget.disabled = false;
    } else {
      this.subscriptionFieldTarget.value = '';
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
