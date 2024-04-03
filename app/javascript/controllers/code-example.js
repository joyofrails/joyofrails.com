import { Controller } from '@hotwired/stimulus';
import debug from '../utils/debug';

import { isWorkerInitialized, sendWorkerRequest } from './code-example/rails';

const console = debug('app:javascript:controllers:code-example');

export default class extends Controller {
  static targets = ['source', 'status', 'result', 'output'];

  connect() {
    console.log('connect');
  }

  showBootMessage() {
    if (!isWorkerInitialized()) {
      this.updateStatus('Just a moment...');
      this.bootTimeout = setTimeout(() => {
        this.updateStatus('This is taking longer than expected...');
      }, 10000);
    }
  }

  clearBootMessage() {
    if (this.bootTimeout) {
      clearTimeout(this.bootTimeout);
      this.bootTimeout = null;
    }
    this.updateStatus('');
  }

  async run() {
    console.log('run', this.sourceTarget.innerText);
    const source = this.sourceTarget.innerText;

    try {
      this.showBootMessage();
      const { result, output } = await sendWorkerRequest({
        message: 'EVAL',
        source,
      });
      this.clearBootMessage();
      this.updateResult({ result, output });
    } catch (error) {
      this.updateStatus('An error occurred. Please check the console.');
      throw error;
    }
  }

  updateStatus(message) {
    this.statusTarget.innerText = message;
  }

  updateResult({ result, output }) {
    if (result) {
      this.resultTarget.classList.remove('hidden');
      this.resultTarget.querySelector('code').innerText = `=> ${result}`;
    } else {
      this.resultTarget.classList.add('hidden');
      this.resultTarget.querySelector('code').innerText = '';
    }

    if (output?.length) {
      this.outputTarget.classList.remove('hidden');
      this.outputTarget.querySelector('code').innerText = output;
    } else {
      this.outputTarget.classList.add('hidden');
      this.outputTarget.querySelector('code').innerText = '';
    }
  }

  disconnect() {
    console.log('disconnect');
  }
}
