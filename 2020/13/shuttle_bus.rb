def earliest_bus(arrival, departures)
  earliest_d, wait = departures.map do |departure|
    [departure, departure - arrival % departure]
  end.min_by(&:last)
  earliest_d * wait
end

# @param departures [Array<Integer, Integer>] 2-tuples of departure
# and the modulo it needs to satisfy, ex. [[7, 1], [13, 2], [59, 5]]
def earliest_timestamp(departures)
  max_d, modulo = departures.max_by(&:first)
  x = -modulo
  # first_d = departures.first.first
  # x = 0
  all_modulos = false
  until all_modulos
    x += max_d
    # x += first_d
    all_modulos = departures.all? { |d, mod| (d - x % d) == mod }
  end
  x
end

f = File.new('input.txt')
lines = f.readlines
arrival = lines.first.to_i
departures = lines[1].split(',').reject { |char| char == 'x' }
                     .map(&:to_i)
puts earliest_bus(arrival, departures)

# part 2
departures = lines[1].split(',').each_with_index.map do |d, i|
  if d == 'x'
    nil
  elsif i == 0
    [d.to_i, d.to_i]
  else
    [d.to_i, i]
  end
end.compact
# puts earliest_timestamp(departures)
