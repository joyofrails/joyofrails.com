// Docs: https://tailwindcss.com/docs/typography-plugin#customizing-the-defaults
// Source: // https://github.com/tailwindlabs/tailwindcss-typography/blob/master/src/styles.js
const round = (num) =>
  num
    .toFixed(7)
    .replace(/(\.[0-9]+?)0+$/, '$1')
    .replace(/\.0$/, '');
const rem = (px) => `${round(px / 16)}rem`;
const em = (px, base) => `${round(px / base)}em`;
const hexToRgb = (hex) => {
  hex = hex.replace('#', '');
  hex = hex.length === 3 ? hex.replace(/./g, '$&$&') : hex;
  const r = parseInt(hex.substring(0, 2), 16);
  const g = parseInt(hex.substring(2, 4), 16);
  const b = parseInt(hex.substring(4, 6), 16);
  return `${r} ${g} ${b}`;
};

module.exports = (theme) => ({
  sm: {
    css: [
      {
        p: {
          marginTop: 0,
        },
        pre: {
          // fontSize: em(12, 14),
          // lineHeight: round(20 / 12),
          // borderRadius: rem(4),

          marginTop: em(20, 12),
          marginBottom: em(20, 12),

          paddingTop: em(12, 12),
          paddingRight: em(12, 12),
          paddingBottom: em(12, 12),
          paddingLeft: em(12, 12),
        },
      },
    ],
  },
  DEFAULT: {
    css: [
      {
        'code::before': {
          content: null,
        },
        'code::after': {
          content: null,
        },
      },
      {
        p: {
          marginTop: 0,
        },
      },
      {
        pre: {
          // fontSize: em(14, 16),
          // lineHeight: round(24 / 14),
          // borderRadius: rem(6),

          marginTop: em(24, 14),
          marginBottom: em(24, 14),

          // marginLeft: `-${em(12, 12)}`,
          // marginRight: `-${em(12, 12)}`,

          paddingTop: em(12, 12),
          paddingRight: em(12, 12),
          paddingBottom: em(12, 12),
          paddingLeft: em(12, 12),
        },
      },
    ],
  },
  lg: {
    css: [
      {
        p: {
          marginTop: 0,
        },
        pre: {
          // fontSize: em(16, 18),
          // lineHeight: round(28 / 16),
          // borderRadius: rem(6),
          marginTop: em(32, 16),
          marginBottom: em(32, 16),

          marginLeft: `-${em(16, 16)}`,
          marginRight: `-${em(16, 16)}`,

          paddingTop: em(16, 16),
          paddingRight: em(16, 16),
          paddingBottom: em(16, 16),
          paddingLeft: em(16, 16),
        },
      },
    ],
  },
  xl: {
    css: [
      {
        p: {
          marginTop: 0,
        },
        pre: {
          // fontSize: em(18, 20),
          // lineHeight: round(32 / 18),
          // borderRadius: rem(8),
          marginTop: em(36, 18),
          marginBottom: em(36, 18),

          marginLeft: `-${em(20, 18)}`,
          marginRight: `-${em(20, 18)}`,

          paddingTop: em(20, 18),
          paddingRight: em(20, 18),
          paddingBottom: em(20, 18),
          paddingLeft: em(20, 18),
        },
      },
    ],
  },
  '2xl': {
    css: [
      {
        p: {
          marginTop: 0,
        },
        pre: {
          // fontSize: em(20, 24),
          // lineHeight: round(36 / 20),
          // borderRadius: rem(8),

          marginTop: em(40, 20),
          marginBottom: em(40, 20),

          marginLeft: `-${em(24, 20)}`,
          marginRight: `-${em(24, 20)}`,

          paddingTop: em(24, 20),
          paddingRight: em(24, 20),
          paddingBottom: em(24, 20),
          paddingLeft: em(24, 20),
        },
      },
    ],
  },
});
