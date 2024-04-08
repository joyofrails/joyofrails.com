import debug from '../../utils/debug';

import { wrapRubyVM } from '../vm';

const console = debug('app:javascript:rails:boot');
console.enable('app:*');

console.log('Booting Rails VM...');

// Rails WASM module is compiled and made available on CDN via wasm pipeline
const railsWasmUrl =
  'https://d21jaoini97l57.cloudfront.net/joyofrails/development/0.0.1/rails-7.1-ruby-3.3-web.wasm';

let railsVM;

export async function bootRailsVM() {
  try {
    if (railsVM) {
      return railsVM;
    }

    railsVM = await wrapRubyVM(railsWasmUrl);

    // Boot the rails environment
    railsVM.eval(
      `
ENV["RAILS_ENV"] = "wasm"
ENV["RAILS_LOG_TO_STDOUT"] = "true"
ENV["SECRET_KEY_BASE"] = "secret"

require "/bundle/setup"
require "/lib/rails-wasm/joy"
    `,
    );

    console.log('Rails initialized!');

    const verbose = true;

    // See if we can run some Ruby code
    railsVM.eval('puts "Hello, Ruby!"', { verbose });
    railsVM.eval('puts [1, 2, 3].map { |n| n * 2 }', { verbose });
  } catch (error) {
    console.error('Error booting Rails VM:', error);
    throw error;
  }

  return railsVM;
}
