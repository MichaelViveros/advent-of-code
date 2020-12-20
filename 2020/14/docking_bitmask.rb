# mask_1s | input -> overwrites input with 1s from mask
# mask_0s & input -> overwrites input with 0s from mask
def apply_mask(mask, value)
  mask_1s = mask.gsub('X', '0').to_i(2)
  mask_0s = mask.gsub('X', '1').to_i(2)
  (value.to_i | mask_1s) & mask_0s
end

f = File.new('input.txt')
lines = f.readlines
instruction_regex = /mem\[([[:digit:]]+)\] = ([[:digit:]]+)/
mask = nil
values_hash = lines.each_with_object({}) do |line, hash|
  if line.include?('mask')
    mask = line.split(' = ').last
  else
    match = instruction_regex.match(line)
    address = match[1]
    value = match[2]
    hash[address] = apply_mask(mask, value)
  end
end
puts values_hash
puts values_hash.values.sum

# part 2
# calculate the offsets of the floating bits, ex. 1F01F, offsets
# = [0,3]
# make a number of the floating bits - 00
# keep incrementing until you get 11 and update the result with
# the corresponding digit at its offset (can keep dividing result by
# 2, taking either that bit or the floating bit depending on the
# offset)
