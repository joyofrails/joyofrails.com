const defaultTheme = require('tailwindcss/defaultTheme');
const typography = require('./tailwind/typography-overrides');

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
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },

      typography: typography,
      colors: {
        // Gray definitions
        'gray-1': 'var(--slate-1)',
        'gray-12': 'var(--slate-12)',
        'gray-base': 'var(--slate-1)',
        'gray-bg-subtle': 'var(--slate-2)',
        'gray-bg': 'var(--slate-3)',
        'gray-bg-hover': 'var(--slate-4)',
        'gray-bg-active': 'var(--slate-5)',
        'gray-line': 'var(--slate-6)',
        'gray-border': 'var(--slate-7)',
        'gray-border-hover': 'var(--slate-8)',
        'gray-solid': 'var(--slate-9)',
        'gray-solid-hover': 'var(--slate-10)',
        'gray-solid-text': '#fff',
        'gray-text': 'var(--slate-11)',
        'gray-text-contrast': 'var(--slate-12)',
        'gray-solid-high-contrast': 'var(--slate-12)',
        'gray-solid-high-contrast-text': 'var(--gray-1)',
        'gray-2-translucent': '#1b1d1eb3',

        // Accent definitions
        'accent-base': 'var(--accent-base)',
        'accent-bg-subtle': 'var(--accent-bg-subtle)',
        'accent-bg': 'var(--accent-bg)',
        'accent-bg-hover': 'var(--accent-bg-hover)',
        'accent-bg-active': 'var(--accent-bg-active)',
        'accent-line': 'var(--accent-line)',
        'accent-border': 'var(--accent-border)',
        'accent-border-hover': 'var(--accent-border-hover)',
        'accent-solid': 'var(--accent-solid)',
        'accent-solid-hover': 'var(--accent-solid-hover)',
        'accent-solid-text': 'var(--accent-solid-text)',
        'accent-text': 'var(--accent-text)',
        'accent-text-contrast': 'var(--accent-text-contrast)',
        'accent-solid-high-contrast': 'var(--accent-solid-high-contrast)',
        'accent-solid-high-contrast-text': 'var(--accent-solid-high-contrast-text)',
        'accent-alpha-ring': 'var(--accent-alpha-ring)',
        'accent-10': 'var(--accent-10)',
        'accent-a2': 'var(--accent-a2)',

        // Component definitions
        overlay: '#09090bcc',
        background: 'var(--accent-base)',
        'bg-card-solid': 'var(--background)',
        'bg-card-translucent': 'var(--gray-2-translucent)',
        'gray-muted': '#a1a1aa',
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
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ],
  darkMode: 'class',
};
