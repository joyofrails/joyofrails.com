import debug from '../../utils/debug';

import { wrapRubyVM } from '../vm';

const console = debug('app:javascript:rails:boot');

const railsWasmUrl =
  'https://d21jaoini97l57.cloudfront.net/wasm-demo-app/0.0.2/rails-7.1-ruby-3.3-web.wasm';

let railsVM;

export async function bootRailsVM() {
  if (railsVM) {
    return railsVM;
  }

  railsVM = await wrapRubyVM(railsWasmUrl);

  railsVM.eval(
    `
ENV["RAILS_ENV"] = "production"
ENV["RAILS_LOG_TO_STDOUT"] = "true"
ENV["SECRET_KEY_BASE"] = "secret"
ENV["ACTIVE_RECORD_ADAPTER"] = "nulldb"

require "/bundle/setup"
require "/lib/wasm_demo"
    `,
  );

  console.log('Rails initialized!');

  const verbose = true;

  railsVM.eval('puts "Hello, Ruby!"', { verbose });
  railsVM.eval('puts [1, 2, 3].map { |n| n * 2 }', { verbose });

  return railsVM;
}
