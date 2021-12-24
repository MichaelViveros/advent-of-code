const fs = require('fs');
const _ = require('lodash');

// INPUT PARSING

function parseInts(str) {
  return str.split(',').map((int) => parseInt(int));
}

// parseInput returns [Segment]
// Segment: { start: { x: Number, y: Number }, end: { x: Number, y: Number } }
function parseInput() {
  const lines = fs.readFileSync('input.txt')
    .toString()
    .trim()
    .split('\n');
  return lines.map((line) => {
    const [start, end] = line.split(' -> ');
    const [startX, startY] = parseInts(start);
    const [endX, endY] = parseInts(end);
    return { start: { x: startX, y: startY }, end: { x: endX, y: endY } };
  });
}

// PART 1

function maxValue({ segments, axis }) {
  const values = segments.flatMap((seg) => {
    if (axis === 'x') {
      return [seg.start.x, seg.end.x];
    }
    return [seg.start.y, seg.end.y];
  });
  return _.max(values) + 1;
}

function createGrid({ segments }) {
  const maxX = maxValue({ segments, axis: 'x' });
  const maxY = maxValue({ segments, axis: 'y' });
  const rows = [...Array(maxY)];
  return rows.map((_row) => _.fill(Array(maxX), 0));
}

function isHorizontal({ segment }) {
  return segment.start.y === segment.end.y;
}

function isVertical({ segment }) {
  return segment.start.x === segment.end.x;
}

/* eslint-disable no-param-reassign */
function markSegment({ segment, grid, horizontal }) {
  const start = horizontal ? segment.start.x : segment.start.y;
  let end = horizontal ? segment.end.x : segment.end.y;
  if (start < end) {
    end += 1;
  } else {
    end -= 1;
  }
  _.range(start, end).forEach((i) => {
    const x = horizontal ? i : segment.start.x;
    const y = horizontal ? segment.start.y : i;
    grid[y][x] += 1;
  });
}
/* eslint-enable no-param-reassign */

function markSegments({ segments }) {
  const grid = createGrid({ segments });
  segments.forEach((segment) => {
    if (isHorizontal({ segment })) {
      markSegment({ segment, grid, horizontal: true });
    } else if (isVertical({ segment })) {
      markSegment({ segment, grid, horizontal: false });
    }
  });
  return grid;
}

function countOverlap({ grid }) {
  return _.flatten(grid).filter((value) => value > 1).length;
}

function solvePart1({ segments }) {
  const grid = markSegments({ segments });
  console.log(countOverlap({ grid }));
}

const segments = parseInput();
solvePart1({ segments });
