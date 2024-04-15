import { defineConfig } from 'vite';
import Rails from 'vite-plugin-rails';

export default defineConfig({
  plugins: [
    Rails({
      envVars: { RAILS_ENV: process.env.RAILS_ENV || 'development' },
    }),
  ],
});
