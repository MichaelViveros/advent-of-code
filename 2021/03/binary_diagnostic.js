const fs = require('fs');
const _ = require('lodash');

// PART 1

// Solution:
// Convert numbers from binary to decimal.
// Get least significant bit by checking if number is odd or even.
// Count the number of 1 bits and check if 1 is more common than 0.
function solvePart1(lines) {
  const ints = lines.map((line) => parseInt(line, 2));
  const numBits = lines[0].length;
  const numNumbers = ints.length;
  let num1s = 0;
  let gammaBit = 0;
  let epsilonBit = 0;
  let gammaInt = 0;
  let epsilonInt = 0;
  _.range(numBits).forEach((bitIndex) => {
    _.range(numNumbers).forEach((intsIndex) => {
      const bit = ints[intsIndex] % 2;
      num1s += bit;
      // shift bits 1 poition to the the right to move on to next bit
      ints[intsIndex] >>>= 1;
    });
    if (num1s > (numNumbers / 2)) {
      gammaBit = 1;
      epsilonBit = 0;
    } else {
      gammaBit = 0;
      epsilonBit = 1;
    }
    gammaInt += gammaBit * 2 ** bitIndex;
    epsilonInt += epsilonBit * 2 ** bitIndex;
    num1s = 0;
  });
  console.log(gammaInt * epsilonInt);
}

// PART 2

function isolateBit({ int, mask }) {
  return (int & mask) === 0 ? 0 : 1;
}

function filterInts({ ints, bitIndex, matchMostCommon }) {
  const mask = 2 ** bitIndex;
  const num1s = ints.reduce(
    (accum, value) => accum + (isolateBit({ mask, int: value }) % 2),
    0
  );
  let matchingBit;
  if (num1s >= (ints.length / 2)) {
    matchingBit = matchMostCommon ? 1 : 0;
  } else {
    matchingBit = matchMostCommon ? 0 : 1;
  }
  return ints.filter((int) => isolateBit({ int, mask }) === matchingBit);
}

function getRating({ ints, numBits, matchMostCommon }) {
  let bitIndex = numBits - 1;
  let filteredInts = ints;
  while (filteredInts.length > 1) {
    filteredInts = filterInts({ bitIndex, matchMostCommon, ints: filteredInts });
    bitIndex -= 1;
  }
  return filteredInts[0];
}

function solvePart2(lines) {
  const ints = lines.map((line) => parseInt(line, 2));
  const numBits = lines[0].length;
  const oxygenRating = getRating({ ints, numBits, matchMostCommon: true });
  const cO2Rating = getRating({ ints, numBits, matchMostCommon: false });
  console.log(oxygenRating * cO2Rating);
}

function parseInput() {
  return fs.readFileSync('input.txt')
    .toString()
    .trim()
    .split('\n');
}

const lines = parseInput();
solvePart1(lines);
solvePart2(lines);
