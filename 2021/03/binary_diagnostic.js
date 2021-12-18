const { match } = require('assert');
const fs = require('fs')
const _ = require('lodash');

const lines = fs.readFileSync('input.txt')
  .toString()
  .trim()
  .split('\n')

// Part 1:
// Convert numbers from binary to decimal.
// Get least significant bit by checking if number is odd or even.
// Count the number of 1 bits and check if 1 is more common than 0.
function part1(lines) {
  const ints = lines.map((line) => parseInt(line, 2))
  const numBits = lines[0].length
  const numNumbers = ints.length
  let num1s = 0
  let gammaBit = 0
  let epsilonBit = 0
  let gammaInt = 0
  let epsilonInt = 0
  for (let bitIndex = 0; bitIndex < numBits; bitIndex++ ) {
    for (let intsIndex = 0; intsIndex < numNumbers; intsIndex++) {
      const bit = ints[intsIndex] % 2
      num1s += bit
      // shift bits 1 poition to the the right to move on to next bit
      ints[intsIndex] = ints[intsIndex] >>> 1
    }
    if (num1s > (numNumbers / 2)) {
      gammaBit = 1
      epsilonBit = 0
    } else {
      gammaBit = 0
      epsilonBit = 1
    }
    gammaInt += gammaBit * Math.pow(2, bitIndex)
    epsilonInt += epsilonBit * Math.pow(2, bitIndex)
    num1s = 0
  }
  console.log(gammaInt * epsilonInt)
}

part1(lines)

// Part 2:
function part2(lines) {
  const ints = lines.map((line) => parseInt(line, 2))
  const numBits = lines[0].length
  const oxygenRating = rating({ints, numBits, matchMostCommon: true})
  const cO2Rating = rating({ints, numBits, matchMostCommon: false})
  console.log(oxygenRating * cO2Rating)
}

function rating({ints, numBits, matchMostCommon}) {
  // make a mask to isolate the most significant bit
  let mask = 2**(numBits - 1)
  while (ints.length > 1) {
    ints = filterInts({ints, matchMostCommon, mask})
    // move on to the next most significant bit
    mask /= 2
  }
  return ints[0]
}

function filterInts({ints, matchMostCommon, mask}) {
  let num1s = 0
  for (int of ints) {
    num1s += isolateBit({int, mask}) % 2
  }
  let matchingBit
  if (num1s >= (ints.length / 2)) {
    matchingBit = matchMostCommon ? 1 : 0
  } else {
    matchingBit = matchMostCommon ? 0 : 1
  }
  return ints.filter((int) => {
    return isolateBit({int, mask}) == matchingBit
  })
}

function isolateBit({int, mask}) {
  return (int & mask) == 0 ? 0 : 1
}

part2(lines)
