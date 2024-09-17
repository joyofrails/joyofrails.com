import { Controller } from '@hotwired/stimulus';
import { debug } from '../../utils';

const console = debug('app:javascript:controllers:pwa:installation');

let installPromptEvent;

const controllers = new Set();

// Listen for the `beforeinstallprompt` event to customize the install prompt UX with our own button.
// Note that this event is currently only implemented in Chromium based browsers.
// @see https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps/How_to/Trigger_install_prompt
window.addEventListener('beforeinstallprompt', async (event) => {
  const relatedApps = await navigator.getInstalledRelatedApps();
  console.log('Install prompt event', event);
  console.log('Related apps', relatedApps);

  installPromptEvent = event;
  controllers.forEach((controller) => {
    controller.initializeDisplay();
    if (!installPromptEvent) {
      controller.showMessage('Already installed!');
    }
  });
});

window.addEventListener('appinstalled', (event) => {
  console.log('App installed event', event);

  controllers.forEach((controller) => {
    controller.showMessage('Thank you for installing Joy of Rails!');
  });
});

// @see https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps/How_to/Create_a_standalone_app
const isStandaloneApp = window.matchMedia('(display-mode: standalone)').matches;

const supportsInstallPrompt = 'onbeforeinstallprompt' in window;

export default class extends Controller {
  static targets = ['installButton', 'infoButton', 'dialog', 'message'];

  connect() {
    console.log('connect', installPromptEvent);
    controllers.add(this);

    this.initializeDisplay();
  }

  disconnect() {
    controllers.delete(this);
  }

  async install() {
    if (!installPromptEvent) {
      return;
    }
    const result = await installPromptEvent.prompt();
    console.log(`Install prompt was: ${result.outcome}`);
    installPromptEvent = null;
    this.installButtonTarget.disabled = true;
  }

  initializeDisplay() {
    if (isStandaloneApp) {
      this.hideInfoButton();
      this.showInstallButton({ disabled: true });
      this.showMessage('Cool, you are using the standalone app!');
    } else if (supportsInstallPrompt) {
      this.showInstallButton();
      this.hideInfoButton();
    } else {
      this.showInfoButton();
      this.hideInstallButton();
    }
  }

  showInstallButton({ disabled = false } = {}) {
    this.installButtonTarget.classList.remove('hidden');
    this.installButtonTarget.disabled = disabled || !installPromptEvent;
  }

  hideInstallButton() {
    this.installButtonTarget.classList.add('hidden');
  }

  showInfoButton() {
    this.infoButtonTarget.classList.remove('hidden');
  }

  hideInfoButton() {
    this.infoButtonTarget.classList.add('hidden');
  }

  openDialog() {
    this.dialogTarget.showModal();
  }

  closeDialog(e) {
    e.preventDefault();
    this.dialogTarget.close();
  }

  clickOutside(e) {
    if (e.target === this.dialogTarget) {
      this.closeDialog(e);
    }
  }

  showMessage(message) {
    this.messageTarget.textContent = message;
    this.messageTarget.classList.remove('hidden');
  }

  removeMessage() {
    this.messageTarget.textContent = '';
    this.messageTarget.classList.add('hidden');
  }
}
