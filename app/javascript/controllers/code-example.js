import { Controller } from '@hotwired/stimulus';
import { debug } from '../utils';

import { isWorkerInitialized, evaluate } from './code-example/rails';

const console = debug('app:javascript:controllers:code-example');

console.log('RAILS_ENV', import.meta.env.RAILS_ENV);

export default class extends Controller {
  static targets = [
    'source',
    'status',
    'result',
    'output',
    'runButton',
    'clearButton',
  ];

  static values = {
    vm: String,
  };

  connect() {
    console.log('connect', { vm: this.vmValue });
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
      const { result, output } = await evaluate(source);
      this.clearBootMessage();
      this.updateResult({ result, output });
      this.toggleButtons('clear');
    } catch (error) {
      this.updateStatus('An error occurred. Check the console for more info.');
      throw error;
    }
  }

  clear() {
    console.log('clear');
    this.updateStatus('');
    this.updateResult({ result: null, output: null });
    this.toggleButtons('run');
  }

  toggleButtons(action) {
    if (action === 'clear') {
      this.clearButtonTarget.disabled = false;
      this.runButtonTarget.disabled = true;
      this.clearButtonTarget.classList.remove('hidden');
      this.runButtonTarget.classList.add('hidden');
      this.clearButtonTarget.focus();
    } else {
      this.runButtonTarget.disabled = false;
      this.clearButtonTarget.disabled = true;
      this.runButtonTarget.classList.remove('hidden');
      this.clearButtonTarget.classList.add('hidden');
      this.runButtonTarget.focus();
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
