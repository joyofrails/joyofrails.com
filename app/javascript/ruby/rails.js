import initVM from './init-vm';

const railsWasmUrl =
  'https://d21jaoini97l57.cloudfront.net/wasm-demo-app/0.0.2/rails-7.1-ruby-3.3-web.wasm';

export async function initRails(...args) {
  const vm = await initVM(railsWasmUrl, ...args);

  vm.eval(
    `
ENV["RAILS_ENV"] = "production"
ENV["RAILS_LOG_TO_STDOUT"] = "true"
ENV["SECRET_KEY_BASE"] = "secret"
ENV["ACTIVE_RECORD_ADAPTER"] = "nulldb"

require "/bundle/setup"
require "/lib/wasm_demo"
    `,
  );

  return vm;
}
