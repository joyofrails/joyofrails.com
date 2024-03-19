import debug from '../utils/debug';

const console = debug('app:javascript:initializers:ruby-wasm-hello-world');

import { evaluator, initRails } from '../ruby';

export default async function () {
  const rails = await evaluator(initRails);

  const verbose = true;

  rails.evaluate('puts "Hello, Ruby!"', { verbose });
  rails.evaluate('puts [1, 2, 3].map { |n| n * 2 }', { verbose });
  const { result } = rails.evaluate(`HelloController.render("show")`, {
    verbose,
  });
  console.log('result', result);

  globalThis.rails = rails;
}
