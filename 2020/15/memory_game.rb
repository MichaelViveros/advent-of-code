@turn_said = {}

def memory_game(starting_nums)
  @turn_said = starting_nums[0..-2].each_with_index
    .each_with_object({}) do |(num, i), hash|
      hash[num] = i + 1
    end
  num = starting_nums.last
  (starting_nums.size..2019).each do |turn|
    puts "#{turn} #{num}"
    first_time = @turn_said[num].nil?
    next_num = first_time ? 0 : turn - @turn_said[num]
    @turn_said[num] = turn
    num = next_num
  end
  num
end

f = File.new('input.txt')
starting_nums = f.readlines.first.split(',').map(&:to_i)
puts memory_game(starting_nums)
