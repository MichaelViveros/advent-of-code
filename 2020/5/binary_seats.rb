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

f = File.new('input.txt')
seats = f.readlines.map { |l| binary_partition(l) }
puts seats.max
seats.sort!
seat, _index = seats.each_with_index.find { |s, i| seats[i + 1] != s + 1 }
puts seat + 1
