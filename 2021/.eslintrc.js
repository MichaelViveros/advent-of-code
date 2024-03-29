module.exports = {
  env: {
    browser: true,
    commonjs: true,
    es2021: true,
  },
  extends: [
    'airbnb-base',
  ],
  parserOptions: {
    ecmaVersion: 13,
  },
  rules: {
    radix: ['off'],
    'no-console': ['off'],
    'no-bitwise': ['off'],
    'no-unused-vars': [
      'error',
      { 'varsIgnorePattern': '^_', 'argsIgnorePattern': '^_' }
    ],
  },
};
