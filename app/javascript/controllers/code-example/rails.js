// This module encapsulates creation and communication with the Web Worker for
// running the Ruby VM. Message channels are used as a strategy for
// request/response style communication with the worker. This is a better model
// than the `postMessage` default to broadcast.
//
// @see https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API
// @see https://developer.mozilla.org/en-US/docs/Web/API/MessageChannel
// @see https://advancedweb.hu/how-to-use-async-await-with-postmessage/
import debug from '../../utils/debug';

const console = debug('app:javascript:controllers:code:rails');

let worker = null;
let workerInitialized = false;

const sendWorkerPromise = (message) => {
  return new Promise((resolve, reject) => {
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

    console.log('Sending message to worker', message);
    worker.postMessage(message, [channel.port2]);
  });
};

export const initWorker = async () => {
  if (!worker) {
    console.log('Creating new worker');
    worker = new Worker(
      new URL('../../ruby-wasm/rails/worker', import.meta.url),
      {
        type: 'module',
      },
    );
  }

  if (!workerInitialized) {
    console.log('Sending INIT message to worker');
    await sendWorkerPromise({ message: 'INIT' });
    workerInitialized = true;
  }

  return workerInitialized;
};

export const sendWorkerRequest = async (message) => {
  if (!workerInitialized) {
    await initWorker();
  }

  return sendWorkerPromise(message);
};

export const isWorkerInitialized = () => workerInitialized;
