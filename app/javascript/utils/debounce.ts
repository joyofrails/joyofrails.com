function debounce(callback: Function, delay: number) {
  let timeout: number;

  return (...args) => {
    const context = this;
    window.clearTimeout(timeout);

    timeout = window.setTimeout(() => callback.apply(context, args), delay);
  };
}

export { debounce };
