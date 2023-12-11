const defaultTheme = require('tailwindcss/defaultTheme');

module.exports = {
  content: [
    './app/**/*.html.erb',
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.{js,css}',
    './app/assets/stylesheets/**/*.css',
  ],
  safelist: ['group'],
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
        xl: '4rem',
        // '2xl': '1.5rem',
      },
    },
    extend: {
      // Overriding extensions
      // typography: ({ theme }) => ({
      //   default: {
      //     css: {
      //       // pre: null,
      //       // code: null,
      //       // 'code::before': null,
      //       // 'code::after': null,
      //       // 'pre code': null,
      //       // 'pre code::before': null,
      //       // 'pre code::after': null,
      //     },
      //   },
      // }),
      // fontFamily: {
      //   sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      // },
      colors: {
        'theme-base': 'var(--theme-base)',
        'theme-bg-subtle': 'var(--theme-bg-subtle)',
        'theme-bg': 'var(--theme-bg)',
        'theme-bg-hover': 'var(--theme-bg-hover)',
        'theme-bg-active': 'var(--theme-bg-active)',
        'theme-line': 'var(--theme-line)',
        'theme-border': 'var(--theme-border)',
        'theme-border-hover': 'var(--theme-border-hover)',
        'theme-solid': 'var(--theme-solid)',
        'theme-solid-hover': 'var(--theme-solid-hover)',
        'theme-solid-text': 'var(--theme-solid-text)',
        'theme-text': 'var(--theme-text)',
        'theme-text-contrast': 'var(--theme-text-contrast)',
        'theme-solid-high-contrast': 'var(--theme-solid-high-contrast)',
        'theme-solid-high-contrast-text': 'var(--theme-solid-high-contrast-text)',
        'theme-alpha-ring': 'var(--theme-alpha-ring)',
        'theme-10': 'var(--theme-10)',
        'theme-a2': 'var(--theme-a2)',
      },
      fontSize: {
        xs: ['0.75rem', { lineHeight: '1.5' }],
        sm: ['0.875rem', { lineHeight: '1.5715' }],
        base: ['1rem', { lineHeight: '1.5', letterSpacing: '-0.017em' }],
        lg: ['1.125rem', { lineHeight: '1.5', letterSpacing: '-0.017em' }],
        xl: ['1.25rem', { lineHeight: '1.5', letterSpacing: '-0.017em' }],
        '2xl': ['1.5rem', { lineHeight: '1.415', letterSpacing: '-0.017em' }],
        '3xl': ['1.875rem', { lineHeight: '1.333', letterSpacing: '-0.017em' }],
        '4xl': ['2.25rem', { lineHeight: '1.277', letterSpacing: '-0.017em' }],
        '5xl': ['2.75rem', { lineHeight: '1.2', letterSpacing: '-0.017em' }],
        '6xl': ['3.5rem', { lineHeight: '1', letterSpacing: '-0.017em' }],
        '7xl': ['4.5rem', { lineHeight: '1', letterSpacing: '-0.017em' }],
      },
    },
  },
  plugins: [
    // require('@tailwindcss/forms'),
    // require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    // require('@tailwindcss/container-queries'),
  ],
  darkMode: 'class',
};
