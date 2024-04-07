# joyofrails.com

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

### WASM

Joy of Rails is WASM-ified: it is designed to compile to WebAssembly so that it can be loaded directly in the browser.

Install the WASM dependencies:

- Install [wasi-vfs](https://github.com/kateinoigakukun/wasi-vfs):

  ```sh
  brew tap kateinoigakukun/wasi-vfs https://github.com/kateinoigakukun/wasi-vfs.git
  brew install kateinoigakukun/wasi-vfs/wasi-vfs
  ```

- Install Rust toolchain:

  ```sh
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  ```

The minimal WASM version of the app can be built as follows:

- Build the WASM module and "pack" the Rails app (this take awhile first time):

  ```sh
  bin/wasm-build-web
  ```

- Compress the WASM module and copy to the assets directory:

  ```sh
  bin/wasm-compress-web
  ```

## License

Copyright 2024 Ross Kaffenberger under the [BSD 3 Clause License](https://opensource.org/license/bsd-3-clause).
