const defaultTheme = require('tailwindcss/defaultTheme');

module.exports = {
  content: [
    './app/**/*.html.erb',
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.{js,css}',
    './app/assets/stylesheets/**/*.css',
  ],
  theme: {
    container: {
      center: true,
      // default breakpoints but with 40px removed
      screens: {
        sm: '600px',
        md: '728px',
        lg: '984px',
        xl: '1240px',
        // '2xl': '1496px',
      },
      padding: {
        DEFAULT: '1rem',
        // sm: '1rem',
        // lg: '1rem',
        xl: '1.5rem',
        // '2xl': '1.5rem',
      },
    },
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    // require('@tailwindcss/forms'),
    // require('@tailwindcss/aspect-ratio'),
    // require('@tailwindcss/typography'),
    // require('@tailwindcss/container-queries'),
  ],
  darkMode: 'class',
};
