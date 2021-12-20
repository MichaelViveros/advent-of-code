const fs = require('fs');
const _ = require('lodash');

// INPUT PARSING

// parseBoards returns [Board]
// Board: {
//   nums: [BoardNum],
//   rowsMarked: [Number],
//   columnsMarked: [Number],
//   marked: Boolean,
// }
// BoardNum: {
//   value: Number,
//   row: Number,
//   column: Number,
//   marked: Boolean,
// }
function parseBoards({ lines }) {
  return _.chunk(lines, 6)
    .map((board) => {
      const nums = board.slice(1)
        .flatMap((row, rowIndex) => {
          const rowNums = _.compact(row.split(' '));
          return rowNums.map((columnNum, columnIndex) => ({
            row: rowIndex,
            column: columnIndex,
            value: parseInt(columnNum),
            marked: false,
          }));
        });
      const rowsMarked = _.fill(Array(5), 0);
      const columnsMarked = _.fill(Array(5), 0);
      return {
        nums, rowsMarked, columnsMarked, marked: false,
      };
    });
}

function parseInput() {
  const lines = fs.readFileSync('input.txt')
    .toString()
    .trim()
    .split('\n');
  const numsDrawn = lines[0]
    .split(',')
    .map((numStr) => parseInt(numStr));
  const boards = parseBoards({ lines: lines.slice(1) });
  return { numsDrawn, boards };
}

// PART 1

/* eslint-disable no-param-reassign */
function markNum({ num, board }) {
  if (board.marked) return false;
  const boardNum = board.nums.find((n) => n.value === num);
  if (boardNum) {
    boardNum.marked = true;
    board.rowsMarked[boardNum.row] += 1;
    board.columnsMarked[boardNum.column] += 1;
    const rowCount = board.rowsMarked[boardNum.row];
    const columnCount = board.columnsMarked[boardNum.column];
    if (rowCount === 5 || columnCount === 5) {
      board.marked = true;
      return true;
    }
  }
  return false;
}
/* eslint-enable no-param-reassign */

function getWinningBoard({ numsDrawn, boards, pickFirstWinner }) {
  const turns = numsDrawn.flatMap(
    (num) => boards.map((board) => ({ num, board })),
  );
  if (pickFirstWinner) {
    return turns.find(({ num, board }) => markNum({ num, board }));
  }
  return turns.reduce((prevTurn, turn) => markNum(turn) ? turn : prevTurn);
}

function solve({ numsDrawn, boards, pickFirstWinner }) {
  const { num, board } = getWinningBoard({ numsDrawn, boards, pickFirstWinner });
  const [_markedNums, unmarkedNums] = _.partition(
    board.nums,
    (boardNum) => boardNum.marked,
  );
  const unmarkedSum = _.sumBy(unmarkedNums, (boardNum) => boardNum.value);
  console.log(unmarkedSum * num);
}

const { numsDrawn, boards } = parseInput();
// Part 1
solve({ numsDrawn, boards: _.cloneDeep(boards), pickFirstWinner: true });
// Part 2
solve({ numsDrawn, boards: _.cloneDeep(boards), pickFirstWinner: false });
