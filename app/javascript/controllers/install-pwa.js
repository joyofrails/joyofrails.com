import { Controller } from '@hotwired/stimulus';
import debug from 'debug';

const log = debug('app:javascript:controllers:install-pwa');

let installPromptEvent;

const controllers = new Set();

window.addEventListener('beforeinstallprompt', (event) => {
  event.preventDefault();
  installPromptEvent = event;
  controllers.forEach((controller) => controller.showInstallButton());
});

// Reference: https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps/How_to/Create_a_standalone_app
const isStandaloneApp = () =>
  window.matchMedia('(display-mode: standalone)').matches;

export default class extends Controller {
  static targets = ['installButton'];

  connect() {
    controllers.add(this);

    if (isStandaloneApp()) {
      this.hideInstallButton();
    } else if (installPromptEvent) {
      this.showInstallButton();
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

  hideInstallButton() {
    this.installButtonTarget.classList.add('hidden');
  }

  showInstallButton() {
    this.installButtonTarget.classList.remove('hidden');
  }
}
