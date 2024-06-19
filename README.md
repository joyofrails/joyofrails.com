# joyofrails.com

[![Build Status](https://github.com/joyofrails/joyofrails.com/workflows/verify.yml/badge.svg)](https://github.com/joyofrails/joyofrails.com/actions)
[![Deploy Status](https://github.com/joyofrails/joyofrails.com/workflows/deploy.yml/badge.svg)](https://github.com/joyofrails/joyofrails.com/actions)
[![Code Coverage](https://codecov.io/gh/joyofrails/joyofrails.com/graph/badge.svg?token=PRKDIXWQ7I)](https://codecov.io/gh/joyofrails/joyofrails.com)

A place to learn and celebrate the joy of using Ruby on Rails

https://www.joyofrails.com

## Overview

Building a Rails application to help people learn more about building Rails applications.

- One Person Framework: Rails provides all one person needs to build a robust frontend experience with [Hotwire](https://hotwired.dev/).
- Minimal moving pieces: Prefer SQLite as a database. Single server hosting.
- Vanilla Rails: Rely on Rails conventions. Avoid needless abstractions. Introduce gems judiciously (or for educational value).

## Development

### Requirements

- Ruby, see `.ruby-version`

  Use a Ruby version manager to install and manage Ruby versions, such as

  - [asdf](https://asdf-vm.com/)
  - [rvm](https://rvm.io/)
  - [chruby](https://github.com/postmodern/chruby)

  To use YJIT, Rust must first be installed and be found on `PATH`:

  1. See https://www.rust-lang.org/tools/install for instructions on installing Rust
  2. Then install the correct version of Ruby using preferred version manager:

- [Node](https://nodejs.org/en/), see `.node-version`, `brew install node` or use NVM
- A process manager for Procfile-based applications, either

  - [foreman](https://github.com/ddollar/foreman) - installs automatically, unless using
  - [overmind](https://github.com/DarthSim/overmind)

### Setup

Run the installation script to get the application set up. It is intended to be idempotent and can be run multiple times:

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

Run the following to run all tests

```
bin/verify
```

## License

Copyright 2024 Ross Kaffenberger under the [BSD 3 Clause License](https://opensource.org/license/bsd-3-clause).
