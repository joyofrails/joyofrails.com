import chroma from 'chroma-js';

export const getColor = (color) => chroma(color);

export const getPalette = (color) => {
  const colors = chroma.scale(['white', color, 'black']);
  const palette = [];

  // Create 50
  palette.push(colors(0.05).hex());

  // Create 100-900
  for (let i = 0.1; i < 0.9; i += 0.1) {
    palette.push(colors(i).hex());
  }

  // Create 950
  palette.push(colors(0.95).hex());

  return palette;
};

export const isValid = (color) => chroma.valid(color);

export const getColorPalette = (color, name = 'myColor') => {
  const palette = getPalette(color);
  return {
    [name]: {
      50: palette[0],
      100: palette[1],
      200: palette[2],
      300: palette[3],
      400: palette[4],
      500: palette[5],
      600: palette[6],
      700: palette[7],
      800: palette[8],
      900: palette[9],
      950: palette[10],
    },
  };
};

export const setColorPalette = (color) => {
  const palette = getColorPalette(color);
  Object.keys(palette.myColor).forEach((key) => {
    document.documentElement.style.setProperty(
      `--my-color-${key}`,
      palette.myColor[key],
    );
  });
};
