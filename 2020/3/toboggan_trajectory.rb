TREE = '#'
OPEN = '.'

def trees_on_path(map)
  rows_size = map.size
  columns_size = map[0].size
  # path is a series of slopes where each slope moves right 3 and down 1
  # path ends when we reach last row, so there's rows_size slopes in total
  rows = (1..rows_size - 1)
  # columns repeat forever but we only get the initial set of columns
  # so we have to take modulo
  columns = (1..rows_size - 1).map { |c| c * 3 % columns_size }
  # [[1, 3], [2, 6], ...]
  rows.zip(columns).reduce(0) do |sum, (row, column)|
    map[row][column] == TREE ? sum + 1 : sum
  end
end

# input:
# ..##.......
# #...#...#..
# ...
f = File.new("input.txt")
map = f.readlines.map { |l| l.strip.chars }
puts trees_on_path(map)
