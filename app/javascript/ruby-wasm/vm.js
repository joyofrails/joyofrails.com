// Adapted from Evil Martians' First Steps with Ruby-WASM
// @see https://evilmartians.com/chronicles/first-steps-with-ruby-wasm-or-building-ruby-next-playground
import { RubyVM } from '@ruby/wasm-wasi';
import { File, WASI, OpenFile, ConsoleStdout } from '@bjorn3/browser_wasi_shim';

import { debug } from '../utils';

const console = debug('app:javascript:ruby:evaluator');

export async function initVM(
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

// Encapsulates a Ruby VM instance and provides an interface to evaluate Ruby
// code and flush output.
export async function wrapRubyVM(wasmUrl) {
  const output = [];

  const vm = await initVM(wasmUrl, {
    setStdout: (val) => {
      console.log(val);
      output.push(val);
    },
    setStderr: (val) => {
      console.warn(val);
      output.push(`[warn] ${val}`);
    },
  });

  const flush = () => output.splice(0, output.length).join('\n');

  const evaluate = (source, { verbose = false } = {}) => {
    if (verbose) console.log(`$ ${source}`);

    const result = vm.eval(source).toString();
    const flushed = flush();

    return { result, output: flushed };
  };

  const evalAsync = async (source, { verbose = false } = {}) => {
    if (verbose) console.log(`$ ${source}`);

    const result = await vm.evalAsync(source).toString();
    const flushed = flush();

    return { result, output: flushed };
  };

  return {
    evaluate,
    eval: evaluate,
    evalAsync,
  };
}
