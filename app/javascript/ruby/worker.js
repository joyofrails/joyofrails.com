import debug from '../utils/debug';

import { evaluator } from './evaluator';
import { initRails } from './rails';

const console = debug('app:javascript:ruby:worker');
console.enable('app:*');
console.log('Running ruby worker!');

let rails;

async function helloWorld() {
  if (rails) {
    return Promise.resolve(rails);
  }

  rails = await evaluator(initRails);

  const verbose = true;

  rails.eval('puts "Hello, Ruby!"', { verbose });
  rails.eval('puts [1, 2, 3].map { |n| n * 2 }', { verbose });

  return Promise.resolve(rails);
}

self.addEventListener('message', async ({ data, ports }) => {
  console.log('Message received from main script', data);
  const [port] = ports;

  if (data.message === 'INIT') {
    await helloWorld();

    port.postMessage({ message: 'READY' });
  }

  if (data.message === 'EVAL') {
    const { result, output } = rails.eval(data.source);
    port.postMessage({ message: 'RESULT', result, output });
  }

  if (data.message === 'EVAL_ASYNC') {
    const { result, output } = await rails.evalAsync(data.source);
    port.postMessage({ message: 'RESULT', result, output });
  }
});
