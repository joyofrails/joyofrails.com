import { Controller } from '@hotwired/stimulus';
import debug from 'debug';

const log = debug('app:javascript:controllers:code');

let worker = null;
let workerInitialized = false;

const initWorker = () => {
  return new Promise((resolve) => {
    if (workerInitialized) {
      resolve();
    }

    if (!worker) {
      worker = new Worker(new URL('../ruby/worker', import.meta.url), {
        type: 'module',
      });
    }

    const channel = new MessageChannel();

    channel.port1.onmessage = ({ data }) => {
      console.log('Message received from worker', data);

      if (data.message === 'READY') {
        channel.port1.close();

        console.log('Worker is ready');
        workerInitialized = true;

        resolve();
      }
    };

    worker.postMessage({ message: 'INIT' }, [channel.port2]);
  });
};

const evaluate = (source) => {
  return new Promise((resolve, reject) => {
    const channel = new MessageChannel();

    channel.port1.onmessage = ({ data }) => {
      console.log('Message received from worker', data);

      channel.port1.close();
      if (data.error) {
        reject(data.error);
      } else {
        resolve({ result: data.result, output: data.output });
      }
    };

    worker.postMessage({ message: 'EVAL', source }, [channel.port2]);
  });
};

export default class extends Controller {
  static targets = ['source', 'status', 'result', 'output'];

  connect() {
    log('connect');
  }

  async run() {
    log('run', this.sourceTarget.innerText);

    this.updateStatus('Just a moment...');

    await initWorker();

    const source = this.sourceTarget.innerText;

    try {
      const { result, output } = await evaluate(source);
      this.updateStatus('');
      this.updateResult({ result, output });
    } catch (error) {
      this.updateStatus(error);
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
    log('disconnect');
  }
}
