# joyofrails.com

[![Build Status](https://github.com/joyofrails/joyofrails.com/actions/workflows/verify.yml/badge.svg)](https://github.com/joyofrails/joyofrails.com/actions)
[![Deploy Status](https://github.com/joyofrails/joyofrails.com/actions/workflows/deploy.yml/badge.svg)](https://github.com/joyofrails/joyofrails.com/actions)

A place to learn and celebrate the joy of using Ruby on Rails

https://joyofrails.com

Made with joy by @rossta

## Overview

Building a Rails application to help people learn more about building Rails applications.

- Rails 8 with Active Record, [Solid Queue](https://github.com/rails/solid_queue), [Solid Cache](https://github.com/rails/solid_cache), and [Solid Cable](https://github.com/rails/solid_cable)
- [SQLite](https://sqlite.org/) as a database
- [Hotwire](https://hotwired.dev/) for interactivity
- Asset pipeline with [Vite](https://vite.dev/), via [Vite Ruby](https://vite-ruby.netlify.app/), and [Propshaft](https://github.com/rails/propshaft)
- Markdown, ERb, and [Phlex](https://www.phlex.fun/) for HTML

## Development

### Requirements

- [Ruby](https://www.ruby-lang.org/en/), see `.ruby-version`
- [Node](https://nodejs.org/en/), see `.node-version`

### Setup

Run setup script to install dependencies and initialize the database.

```
bin/setup
```

### Server

Run the following to start the server and automatically build assets.

```
bin/dev
```

### Test

Run RSpec tests

```
bin/rspec
```

Run Jest tests

```
npm run test
```

Linting

```
bin/lint
```

Run the following to run all tests

```
bin/verify
```

## Docs

- [CONTRIBUTING.md](./docs/CONTRIBUTING.md)
- [SECURITY.md](./docs/SECURITY.md)
- [CODE_OF_CONDUCT.md](./docs/CODE_OF_CONDUCT.md)

## License

Copyright 2024 Ross Kaffenberger under the [BSD 3 Clause License](https://opensource.org/license/bsd-3-clause).
