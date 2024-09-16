import _debug from 'debug';

export const debug = (namespace) => {
  return {
    enable: _debug.enable.bind(debug),
    log: _debug(namespace),
    error: (() => {
      const error = _debug(namespace);
      error.log = console.error.bind(console);
      return error;
    })(),
    warn: (() => {
      const warn = _debug(namespace);
      warn.log = console.warn.bind(console);
      return warn;
    })(),
  };
};
