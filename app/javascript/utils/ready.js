export default function $(run) {
  if (document.readyState != 'loading') {
    run();
  } else {
    document.addEventListener('DOMContentLoaded', run);
  }
}
