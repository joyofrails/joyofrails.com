# WASM on Rails

Joy of Rails is WASM-ified: it is designed to compile to WebAssembly so that it can be loaded directly in the browser.

## Development

To create a WASM build of the application locally, first

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

The minimal WASM version of the app can be built and compiled with

```sh
bin/wasm/all
```

Alternatively, the steps of the WASM "all" process can be run separately:

- Compile static assets

  ```sh
  bin/rails assets:precompile
  ```

- Build the ruby WASM module (this take awhile first time):

  ```sh
  bin/wasm/build
  ```

- Pack the Rails app code to produce the Ruby+Rails WASM module:

  ```sh
  bin/wasm/pack
  ```

- Compress the WASM module and copy to the assets directory:

  ```sh
  bin/wasm/compress
  ```

- Upload the module to S3.

  ```sh
  bin/rails wasm:upload
  ```

  This step assumes S3 access key id in the corresponding config/credentials file for the given Rails environment.

  ```
  wasm:
    aws:
      access_key_id: AKI*****************
      secret_access_key: ****************************************
  ```

## Versioning

The WASM app moudle in production depends on three values: the Ruby major-minor version (e.g. `3.2`), the Rails major-minor version (e.g. `7.1`), and the value ini [`../WASM_APP_VERSION`](../WASM_APP_VERSION).

A new version of the app will only be created in S3 if this one or more of these values are incremented. If upgrading Ruby or Rails, we should increment the WASM app version as well. Right now, this is a manual process. To avoid unnecessary churn, we do not incrementing the WASM app version with each changeset and only rarely.
