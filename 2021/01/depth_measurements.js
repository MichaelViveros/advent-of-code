const fs = require('fs');
const _ = require('lodash');

const measurements = fs.readFileSync('input.txt')
  .toString()
  .split('\n')
  .map(((str) => parseInt(str)));

// part 1
const numGreater = measurements.reduce((accum, current, index) => {
  if (index > 0 && current > measurements[index - 1]) {
    return accum + 1;
  }
  return accum;
}, 0);
console.log(numGreater);

// part 2
const numGreaterTriples = measurements.reduce((accum, _current, index) => {
  if (index < measurements.length - 3) {
    const sum1 = _.sum(measurements.slice(index, index + 3));
    const sum2 = _.sum(measurements.slice(index + 1, index + 4));
    return sum2 > sum1 ? accum + 1 : accum;
  }
  return accum;
}, 0);
console.log(numGreaterTriples);
