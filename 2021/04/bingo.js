const fs = require('fs');
const _ = require('lodash');

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
      return { nums, rowsMarked, columnsMarked };
    });
}

// PART 1

/* eslint-disable no-param-reassign */
function markNum({ num, board }) {
  const boardNum = board.nums.find((n) => n.value === num);
  if (boardNum) {
    boardNum.marked = true;
    board.rowsMarked[boardNum.row] += 1;
    board.columnsMarked[boardNum.column] += 1;
    const rowCount = board.rowsMarked[boardNum.row];
    const columnCount = board.columnsMarked[boardNum.column];
    if (rowCount === 5 || columnCount === 5) return true;
  }
  return false;
}
/* eslint-enable no-param-reassign */

function getWinningBoard({ numsDrawn, boards }) {
  const turns = numsDrawn.flatMap(
    (num) => boards.map((board) => ({ num, board })),
  );
  return turns.find(({ num, board }) => markNum({ num, board }));
}

function solvePart1({ numsDrawn, boards }) {
  const { num, board } = getWinningBoard({ numsDrawn, boards });
  const [_markedNums, unmarkedNums] = _.partition(
    board.nums,
    (boardNum) => boardNum.marked,
  );
  const unmarkedSum = _.sumBy(unmarkedNums, (boardNum) => boardNum.value);
  console.log(unmarkedSum * num);
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

const { numsDrawn, boards } = parseInput();
solvePart1({ numsDrawn, boards });
