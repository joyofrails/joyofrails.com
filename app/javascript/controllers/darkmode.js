export default class extends Controller {
  static targets = [];

  connect() {
    console.log('Connected to DarkMode Controller...');
    const darkSwitch = document.getElementById('darkSwitch');
    if (darkSwitch) {
      initTheme(darkSwitch);
      darkSwitch.addEventListener('change', () => {
        resetTheme(darkSwitch);
      });
    }
  }
}
