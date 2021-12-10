const fs = require('fs')

const lines = fs.readFileSync('input.txt')
  .toString()
  .trim()
  .split('\n')
const numBits = lines[0].length
const numNumbers = lines.length
const ints = lines.map((line) => parseInt(line, 2))
let num1s = 0
let gammaBit = 0
let epsilonBit = 0
let gammaInt = 0
let epsilonInt = 0
for (let bitIndex = 0; bitIndex < numBits; bitIndex++ ) {
  for (let intsIndex = 0; intsIndex < numNumbers; intsIndex++) {
    const int = ints[intsIndex]
    num1s += int % 2
    ints[intsIndex] = Math.floor(ints[intsIndex] / 2)
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
