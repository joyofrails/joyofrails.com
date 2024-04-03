import debug from '../../utils/debug';

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
    return port.postMessage({ message: 'RESULT', result, output });
  }

  if (data.message === 'EVAL_ASYNC') {
    const { result, output } = await railsVM.evalAsync(data.source);
    return port.postMessage({ message: 'RESULT', result, output });
  }
});
