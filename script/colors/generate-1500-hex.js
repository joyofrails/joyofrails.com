// Usage: node script/colors/generate-1500-hex.js > script/colors/data/1500-palette-hex.json
//
// This script converts the 1500-colors.mjs file into a JSON object with the
// palette name as the key and a monochrome color scale object as the value.

import { generatePalette } from './palette.mjs';
import { colors } from './data/1500-colors.mjs';

const palettes = colors.reduce((obj, [hex, name]) => {
  obj[name] = generatePalette(hex, name);
  return obj;
}, {});

console.log(JSON.stringify(palettes));
