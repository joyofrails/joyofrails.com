import debug from 'debug';

export default function (namespace) {
  return {
    enable: debug.enable.bind(debug),
    log: debug(namespace),
    error: (() => {
      const error = debug(namespace);
      error.log = console.error.bind(console);
      return error;
    })(),
    warn: (() => {
      const warn = debug(namespace);
      warn.log = console.warn.bind(console);
      return warn;
    })(),
  };
}
