# joyofrails.com

A place to learn and celebrate the joy of using Ruby on Rails

https://www.joyofrails.com

## Getting started

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

## Development

Run the following to start the server and automatically build assets.

```
bin/dev
```

## Test

Run RSpec tests

```
bin/rspec
```

Run Jest tests

```
yarn test
```

Run the following to run all tests

```
bin/rake
```
