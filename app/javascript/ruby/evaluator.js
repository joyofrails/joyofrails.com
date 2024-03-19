import debug from '../utils/debug';

const console = debug('app:javascript:ruby:evaluator');

export async function evaluator(initVm) {
  const output = [];
  const vm = await initVm({
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

  return {
    evaluate,
  };
}
