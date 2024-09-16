// This module is intended to run in a Web Worker. It initializes a WASM Ruby VM and
// responds to messages to evaluate Ruby source code.
//
// @see https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API

import { debug } from '../../utils';

import { bootRailsVM } from './boot';

const console = debug('app:javascript:rails:worker');
console.enable('app:*');
console.log('Running ruby worker!');

let railsVM;

self.addEventListener('message', async ({ data, ports }) => {
  console.log('Message received from main script', data);
  const [port] = ports;

  if (data.message === 'INIT') {
    railsVM = await bootRailsVM();
    return port.postMessage({ message: 'READY' });
  }

  if (!railsVM) {
    return port.postMessage({
      message: 'ERROR',
      error: 'Rails VM not initialized',
    });
  }

  if (data.message === 'EVAL') {
    const { result, output } = railsVM.eval(data.source);
    console.log('Eval result', { source: data.source, result, output });
    return port.postMessage({ message: 'RESULT', result, output });
  }

  if (data.message === 'EVAL_ASYNC') {
    const { result, output } = await railsVM.evalAsync(data.source);
    return port.postMessage({ message: 'RESULT', result, output });
  }
});
