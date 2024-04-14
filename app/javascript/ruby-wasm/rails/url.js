import WASM_APP_VERSION from '../../../../WASM_APP_VERSION?raw';
import debug from '../../utils/debug';

const console = debug('app:javascript:rails:url');
console.enable('app:*');

const CLOUDFRONT_URL = 'https://d21jaoini97l57.cloudfront.net/joyofrails';
const RAILS_ENV = import.meta.env.RAILS_ENV;

let version = '';

if (RAILS_ENV === 'development' || RAILS_ENV === 'test') {
  version += `${RAILS_ENV}/`;
}

version += WASM_APP_VERSION.trim();

// Rails WASM module is compiled and made available on CDN via wasm pipeline
const railsWasmUrl = `${CLOUDFRONT_URL}/${version}/rails-7.1-ruby-3.3-web.wasm`;

console.log('railsWasmUrl', railsWasmUrl);

export default railsWasmUrl;
