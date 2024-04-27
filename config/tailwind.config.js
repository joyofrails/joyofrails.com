import defaultTheme from 'tailwindcss/defaultTheme';
import typography from './tailwind/typography-overrides';
import colors from './tailwind/colors';

export default {
  content: [
    './app/**/*.html.erb',
    './public/*.html',
    './app/views/**/*.rb',
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
      fontFamily: {
        logo: ['Russo One', ...defaultTheme.fontFamily.sans],
      },

      colors: colors,
      typography: typography,
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
      screens: {
        pwa: { raw: '(display-mode: standalone)' },
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ],
  darkMode: 'class',
};
