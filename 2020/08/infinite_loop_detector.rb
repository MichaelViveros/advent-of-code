# store instructions as singly-linked list
class Instruction
  attr_accessor :op, :arg, :next_i, :executed, :index
  def initialize(op, arg, index)
    @op = op
    @arg = arg
    @index = index
    @executed = false
    @next_i = nil
  end

  def execute(accum)
    @executed = true
    return accum + @arg if @op == 'acc'

    accum
  end

  def to_s
    "Instruction - #{@op} #{@arg}, "\
    "next_i #{@next_i&.op} #{@next_i&.arg}, "\
    "executed #{@executed}, index #{@index}"
  end
end

def execute(instructions, start_i, accum)
  instructions.each { |i| i.executed = false }
  i = start_i
  until i.nil? || i.executed
    accum = i.execute(accum)
    i = i.next_i
  end
  reached_end = i.nil?
  [reached_end, accum]
end

def change_instruction(i, new_op, instructions)
  i.op = new_op
  offset = new_op == 'jmp' ? i.arg : 1
  i.next_i = instructions[i.index + offset]
end

f = File.new('input.txt')
i_index = -1
instructions = f.readlines.map do |line|
  i_index += 1
  op,arg = line.split(' ')
  arg = arg.to_i
  Instruction.new(op, arg, i_index)
end
instructions[0..-2].each_with_index do |i, index|
  offset = i.op == 'jmp' ? i.arg : 1
  next_i = instructions[index + offset]
  i.next_i = next_i
end

# part 1
_reached_end, accum = execute(instructions, instructions.first, 0)
puts accum

# part 2
accum = 0
i = instructions.first
until i.nil?
  if i.op == 'jmp'
    change_instruction(i, 'nop', instructions)
    reached_end, accum2 = execute(instructions, i, accum)
    break accum = accum2 if reached_end

    change_instruction(i, 'jmp', instructions)
  elsif i.op == 'nop'
    change_instruction(i, 'jmp', instructions)
    reached_end, accum2 = execute(instructions, i, accum)
    break accum = accum2 if reached_end

    change_instruction(i, 'nop', instructions)
  end
  accum = i.execute(accum)
  i = i.next_i
end
puts accum
