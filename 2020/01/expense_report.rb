TARGET_SUM = 2020

def multiply_two_sum(expense_counts, sum)
  first_num = expense_counts.keys.find do |e|
    expense_counts[sum - e].positive?
  end
  return nil unless first_num

  second_num = sum - first_num
  first_num * second_num
end

def multiply_three_sum(expense_counts)
  two_sum_product = nil # this global-like variable is a bit messy
  third_expense = expense_counts.keys.find do |expense|
    expense_counts[expense] -= 1
    two_sum_product = multiply_two_sum(
      expense_counts,
      TARGET_SUM - expense
    )
    expense_counts[expense] += 1
    !two_sum_product.nil?
  end
  third_expense && third_expense * two_sum_product
end

# input.txt:
# 1918
# 1869
# 1821
# ...
f = File.new('input.txt')
expense_counts = f.readlines.reduce(Hash.new(0)) do |hash, line|
  hash.tap { |h| h[line.to_i] += 1 }
end
puts multiply_two_sum(expense_counts, TARGET_SUM)
puts multiply_three_sum(expense_counts)
