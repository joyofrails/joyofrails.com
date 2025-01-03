import debug from 'debug';

import '@hotwired/turbo-rails';

import '../controllers';

import {
  turboScrollSmoothWorkaround,
  registerServiceWorker,
} from '../initializers';

import * as channels from '../channels';

const log = debug('app:javascript:entrypoints:application');
// To see this message, add the following to the `<head>` section in your
// views/layouts/application.html.erb
//
//    <%= vite_client_tag %>
//    <%= vite_javascript_tag 'application' %>
log('Vite ⚡️ Rails');

// If using a TypeScript entrypoint file:
//     <%= vite_typescript_tag 'application' %>
//
// If you want to use .jsx or .tsx, add the extension:
//     <%= vite_javascript_tag 'application.jsx' %>

// log(
//   'Visit the guide for more information: ',
//   'https://vite-ruby.netlify.app/guide/rails',
// );

// Example: Load Rails libraries in Vite.
//
// import * as Turbo from '@hotwired/turbo'
// Turbo.start()
//
// import ActiveStorage from '@rails/activestorage'
// ActiveStorage.start()
//
// // Import all channels.
// const channels = import.meta.globEager('./**/*_channel.js')

// Example: Import a stylesheet in app/frontend/index.css
// import '~/index.css'

registerServiceWorker();
turboScrollSmoothWorkaround();

window.channels = channels;
