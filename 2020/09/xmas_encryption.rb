PREAMBLE_LENGTH = 25

# @param nums [Array<Integer>] numbers transmitted by xmas protocol
def find_outlier(nums)
  sliding_window = nums[0..PREAMBLE_LENGTH - 1]
    .each_with_object(Set.new) { |num, set| set << num }
  nums[PREAMBLE_LENGTH..-1].each_with_index.find do |num, i|
    is_outlier = sliding_window.all? do |set_num|
      !sliding_window.include?((set_num - num).abs)
    end
    sliding_window.delete(nums[i])
    sliding_window << num
    is_outlier
  end.first
end

def find_conitguous_sum(nums)
  outlier_num = find_outlier(nums)
  start_index = 0
  sum = nums.first
  end_index = (1..nums.size - 1).find do |i|
    puts "#{i} #{nums[i]} #{start_index} #{sum} #{outlier_num}"
    sum += nums[i]
    if sum > outlier_num
      until sum <= outlier_num
        sum -= nums[start_index]
        start_index += 1
      end
      puts "moved start_index to #{start_index}"
    end
    sum == outlier_num
  end
  contiguous_nums = nums[start_index..end_index]
  contiguous_nums.min + contiguous_nums.max
end

f = File.new('input.txt')
starting_nums = f.readlines.map(&:to_i)
puts find_outlier(starting_nums)
puts find_conitguous_sum(starting_nums)
