import { Controller } from '@hotwired/stimulus';
import debug from '../../utils/debug';

const log = debug('app:javascript:controllers:pwa-installation');

let installPromptEvent;

const controllers = new Set();

// Listen for the `beforeinstallprompt` event to customize the install prompt UX with our own button.
// Note that this event is currently only implemented in Chromium based browsers.
// @see https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps/How_to/Trigger_install_prompt
window.addEventListener('beforeinstallprompt', async (event) => {
  event.preventDefault();

  const relatedApps = await navigator.getInstalledRelatedApps();
  log('Related apps', relatedApps);

  installPromptEvent = event;
  controllers.forEach((controller) => controller.showInstallButton());
});

// @see https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps/How_to/Create_a_standalone_app
const isStandaloneApp = window.matchMedia('(display-mode: standalone)').matches;

const supportsInstallPrompt = 'onbeforeinstallprompt' in window;

export default class extends Controller {
  static targets = ['installButton', 'infoButton', 'dialog'];

  connect() {
    controllers.add(this);

    if (isStandaloneApp) {
      this.hideInfoButton();
      this.hideInstallButton();
    } else if (supportsInstallPrompt) {
      this.showInstallButton();
      this.hideInfoButton();
    } else {
      this.showInfoButton();
      this.hideInstallButton();
    }
  }

  disconnect() {
    controllers.delete(this);
  }

  async install() {
    if (!installPromptEvent) {
      return;
    }
    const result = await installPromptEvent.prompt();
    log(`Install prompt was: ${result.outcome}`);
    installPromptEvent = null;
    this.hideInstallButton();
  }

  showInstallButton() {
    this.installButtonTarget.classList.remove('hidden');
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
}
