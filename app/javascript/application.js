// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import '@hotwired/turbo-rails';

import debug from './utils/debug';
import './controllers';

import turboScrollSmoothWorkaround from './initializers/turbo-scroll-smooth-workaround';

import './initializers/serviceworker-companion';

const log = debug('app:javascript:entrypoints:application');
// To see this message, add the following to the `<head>` section in your
// views/layouts/application.html.erb
//
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

turboScrollSmoothWorkaround();
