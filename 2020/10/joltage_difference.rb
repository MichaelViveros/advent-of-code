# @param adapters [Array<Integer>]
def difference(adapters)
  adapters.sort!
  counts = {}
  counts[adapters.min] = 1 # diff between outlet and first adapter
  counts[3] = 1 # diff between last adapter and device
  (0..adapters.size - 2).each_with_object(counts) do |i, c|
    diff = adapters[i + 1] - adapters[i]
    c[diff] += 1
  end
  counts[1] * counts[3]
end

# @param adapters [Array<Integer>]
# counts[i] = counts[i - 1] + counts[i - 2] + counts[i - 3]
# counts[i] is count of arrangements that end in adapter i
# populate counts in bottom-up approach, loop through each adapter
# and increment the counts for adapters it can reach (1, 2 or 3
# jolts away)
def arrangements(adapters)
  # make hash with adapters as keys to allow for O(1) lookups
  adapters_hash = adapters.each_with_object({}) do |adapter, c|
    c[adapter] = 0
  end
  # add outlet (which has joltage of 0) to adapters hash
  adapters_hash[0] = 1
  max = adapters.max
  # counts is size max + 3 + 1
  # +3 to avoid dealing with edge cases on last couple adapters
  # +1 to make counts 1-indexed (cleaner code)
  counts = Array.new(max + 3 + 1).fill(0)
  # initialize count for outlet to 1
  counts[0] = 1
  (0..max).each do |i|
    next unless adapters_hash[i]

    counts[i + 1] += counts[i] if adapters_hash[i + 1]
    counts[i + 2] += counts[i] if adapters_hash[i + 2]
    counts[i + 3] += counts[i] if adapters_hash[i + 3]
  end
  counts[max]
end

f = File.new('input.txt')
adapters = f.readlines.map(&:to_i)
puts difference(adapters)
puts arrangements(adapters)
