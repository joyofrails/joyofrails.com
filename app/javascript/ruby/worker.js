import debug from '../utils/debug';

import { evaluator } from './evaluator';
import { initRails } from './rails';

const console = debug('app:javascript:ruby:worker');
console.enable('app:*');
console.log('Running ruby worker!');

let rails;

async function helloWorld() {
  rails = await evaluator(initRails);

  const verbose = true;

  rails.eval('puts "Hello, Ruby!"', { verbose });
  rails.eval('puts [1, 2, 3].map { |n| n * 2 }', { verbose });

  const { result } = rails.eval(`HelloController.render("show")`, {
    verbose,
  });
}

onmessage = async ({ data }) => {
  console.log('Message received from main script', data);

  if (data.message === 'INIT') {
    await helloWorld();
  }

  if (data.message === 'EVAL') {
    const result = rails.eval(data.source);
    postMessage(result);
  }

  if (data.message === 'EVAL_ASYNC') {
    const result = await rails.evalAsync(data.source);
    postMessage(result);
  }
};
