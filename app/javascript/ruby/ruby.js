import initVM from './init-vm';

const rubyWasmUrl =
  'https://d21jaoini97l57.cloudfront.net/wasm-demo-app/0.0.2/ruby-3.3-web.wasm';

export async function initRuby(...args) {
  return initVM(rubyWasmUrl, ...args);
}
