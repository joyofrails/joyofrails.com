import debug from '../utils/debug';

const console = debug('app:javascript:initializers:ruby-wasm-hello-world');

export default function rubyWasmHelloWorld() {
  console.log('rubyWasmHelloWorld');

  const worker = new Worker(new URL('../ruby/worker', import.meta.url), {
    type: 'module',
  });

  worker.postMessage({ message: 'INIT' });

  worker.onmessage = ({ data }) => {
    console.log('Message received from worker', data);
  };

  const evaluate = (source) => {
    worker.postMessage({ message: 'EVAL', source });
  };

  const evalAsync = (source) => {
    worker.postMessage({ message: 'EVAL_ASYNC', source });
  };

  return {
    eval: evaluate,
    evalAsync,
  };
}
