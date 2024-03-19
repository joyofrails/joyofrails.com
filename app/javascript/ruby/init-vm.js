// Adapted from https://evilmartians.com/chronicles/first-steps-with-ruby-wasm-or-building-ruby-next-playground
import { RubyVM } from '@ruby/wasm-wasi';
import { File, WASI, OpenFile, ConsoleStdout } from '@bjorn3/browser_wasi_shim';

export default async function initVM(
  wasmUrl,
  { setStdout = () => {}, setStderr = () => {} },
) {
  const wasmResponse = fetch(wasmUrl);

  const fds = [
    new OpenFile(new File([])), // stdin
    ConsoleStdout.lineBuffered(setStdout), // stdout
    ConsoleStdout.lineBuffered(setStderr), // stderr
  ];
  const wasi = new WASI([], [], fds, { debug: false });
  const vm = new RubyVM();
  const imports = {
    wasi_snapshot_preview1: wasi.wasiImport,
  };
  vm.addToImports(imports);

  const { _module, instance } = await WebAssembly.instantiateStreaming(
    wasmResponse,
    imports,
  );
  await vm.setInstance(instance);

  wasi.initialize(instance);
  vm.initialize();

  return vm;
}
