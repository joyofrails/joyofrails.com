module.exports = {
  plugins: {
    'postcss-import': {},
    'tailwindcss/nesting': {},
    tailwindcss: { config: './config/tailwind.config.js' },
    autoprefixer: {},
  },
};
