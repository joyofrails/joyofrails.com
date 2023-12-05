module.exports = {
  rootDir: '../../..',
  setupFilesAfterEnv: ['./app/javascript/jest/setup.js'],
  testMatch: ['**/*.spec.js'],
  cacheDirectory: './tmp/cache/jest',
  moduleNameMapper: {
    '@javascripts(.*)$': '<rootDir>/app/javascript$1',
  },
  testEnvironment: 'jsdom',
  transformIgnorePatterns: [],
};
