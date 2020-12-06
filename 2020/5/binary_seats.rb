# FBFBBFFRLR
# 0-127
# F: 0-63
# B; 32-63
# F: 32-47
# ...
def binary_move(start_i, end_i, char, left_marker)
  middle = start_i + (end_i - start_i) / 2
  char == left_marker ? [start_i, middle] : [middle + 1, end_i]
end

def binary_partition(seat)
  row = seat[0..6].chars.reduce([0, 127]) do |(start_i, end_i), char|
    binary_move(start_i, end_i, char, 'F')
  end.first
  column = seat[7..9].chars.reduce([0, 7]) do |(start_i, end_i), char|
    binary_move(start_i, end_i, char, 'L')
  end.first
  row * 8 + column
end

# @param seat [String] encoded seat number like 'FBFFBBFRLR'
# @return [Integer] decoded seat number
# decodes row by converting encoded row to binary number
# does same thing for column
def binary_partition2(seat)
  row_binary = seat[0..6].gsub('F', '0').gsub('B', '1')
  row_decimal = row_binary.to_i(2)
  column_binary = seat[7..9].gsub('L', '0').gsub('R', '1')
  column_decimal = column_binary.to_i(2)
  row_decimal * 8 + column_decimal
end

f = File.new('input.txt')
lines = f.readlines
seats = lines.map { |l| binary_partition(l) }
puts seats.max
seats.sort!
seat, _index = seats.each_with_index.find do |s, i|
  seats[i + 1] != s + 1
end
puts seat + 1

puts 'using binary numbers:'
seats2 = lines.map { |l| binary_partition2(l) }
puts seats2.max
seats2.sort!
seat2, _index2 = seats2.each_with_index.find do |s, i|
  seats2[i + 1] != s + 1
end
puts seat2 + 1
