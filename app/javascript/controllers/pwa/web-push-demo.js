import { Controller } from '@hotwired/stimulus';
import debug from '../../utils/debug';

const console = debug('app:javascript:controllers:pwa-web-push-demo');

export default class extends Controller {
  static targets = ['sendPushDemoFieldset', 'subscriptionField', 'error'];

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
    }
  }

  onSubscriptionChanged({ detail: { subscription } }) {
    console.log('onSubscriptionChanged');
    this.setSubscription(subscription);
  }

  onError({ detail: { error } }) {
    console.log('onError');
    this.setError(error);
  }

  setSubscription(subscription) {
    console.log('setSubscription', subscription ? subscription.toJSON() : null);

    if (subscription) {
      this.subscriptionFieldTarget.value = JSON.stringify(subscription);
      this.sendPushDemoFieldsetTarget.disabled = false;
    } else {
      this.subscriptionFieldTarget.value = '';
      this.sendPushDemoFieldsetTarget.disabled = true;
    }
  }

  setError(error) {
    console.warn('setError', error);
    const message = error ? error.message || error : '';

    this.errorTarget.textContent = message;

    if (message.length) {
      this.errorTarget.classList.remove('hidden');
    } else {
      this.errorTarget.classList.add('hidden');
    }
  }

  disconnect() {
    console.log('disconnect');
  }
}
