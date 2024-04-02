import { Controller } from '@hotwired/stimulus';
import debug from '../utils/debug';

const console = debug('app:javascript:controllers:code');

let worker = null;
let workerInitialized = false;

const sendWorkerRequest = async (message) => {
  return new Promise((resolve) => {
    const channel = new MessageChannel();

    channel.port1.onmessage = ({ data }) => {
      console.log('Message received from worker', data);

      channel.port1.close();

      if (data.error) {
        reject(data.error);
      } else {
        resolve(data);
      }
    };

    worker.postMessage(message, [channel.port2]);
  });
};

const initWorker = async () => {
  if (!worker) {
    worker = new Worker(new URL('../ruby/worker', import.meta.url), {
      type: 'module',
    });
  }

  if (!workerInitialized) {
    await sendWorkerRequest({ message: 'INIT' });
    workerInitialized = true;
  }

  return workerInitialized;
};

export default class extends Controller {
  static targets = ['source', 'status', 'result', 'output'];

  connect() {
    console.log('connect');
  }

  async initWorker() {
    let timeout;
    if (!worker) {
      this.updateStatus('Just a moment...');
      timeout = setTimeout(() => {
        this.updateStatus('This is taking longer than expected...');
      }, 10000);
    }

    await initWorker();

    if (timeout) {
      clearTimeout(timeout);
    }
  }

  async run() {
    console.log('run', this.sourceTarget.innerText);

    await this.initWorker();

    const source = this.sourceTarget.innerText;

    try {
      const { result, output } = await sendWorkerRequest({
        message: 'EVAL',
        source,
      });
      this.updateStatus('');
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
