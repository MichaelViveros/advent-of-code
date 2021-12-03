const fs = require('fs')

function Command(direction, units) {
  this.direction = direction
  this.units = units
}

function Submarine(x = 0, y = 0, aim = 0) {
  this.x = x
  this.y = y
  this.aim = aim
  this.dive = function({direction, units}) {
    switch (direction) {
      case 'forward':
        this.x += units
        this.y += this.aim * units
        break;
      case 'down':
        this.aim += units
        break;
      case 'up':
        this.aim -= units
        break
      default:
        break;
    }
  }
}

const commands = fs.readFileSync('input.txt')
  .toString()
  .trim()
  .split('\n')
  .map((line => {
    const values = line.split(' ')
    return new Command(values[0], parseInt(values[1]))
  }))

const sub = new Submarine()
for (let command of commands) {
  sub.dive(command)
}
console.log(sub.x * sub.y)
