TREE = '#'
OPEN = '.'
SLOPE = [3, 1]
SLOPES = [[1, 1], SLOPE, [5, 1], [7, 1], [1, 2]]

def trees_on_path(map, slope)
  num_rows = map.size
  num_columns = map[0].size
  slope_right, slope_down = slope
  # path is a sequence of stops where each stop moves slope_right right and slope_down down
  # since we start in the first row, there are num_rows - 1 rows left to traverse
  num_stops = (num_rows - 1) / slope_down
  rows = (1..num_stops).map { |r| r * slope_down }
  # the columns repeat forever but our map only contains the initial set of columns
  # so we have to modulo the current column with num_columns
  columns = (1..num_stops).map { |c| c * slope_right % num_columns }
  rows.zip(columns).count { |(row, column)| map[row][column] == TREE }
end

def multiply_paths(map, slopes)
  slopes.map { |s| trees_on_path(map, s) }
    .reduce(:*)
end

# input:
# ..##.......
# #...#...#..
# _more lines_
f = File.new("input.txt")
map = f.readlines.map { |l| l.strip.chars }
puts multiply_paths(map, [SLOPE])
puts multiply_paths(map, SLOPES)
