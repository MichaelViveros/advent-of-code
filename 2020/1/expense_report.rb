TARGET_SUM = 2020

def multiply_two_sum(expense_counts, sum)
    first_num = expense_counts.keys.find { |e| expense_counts[sum - e] > 0 }
    return nil unless first_num
    second_num = sum - first_num
    return nil if first_num == second_num && expense_counts[first_num] < 2
    puts "multiply_two_sum #{sum}, #{first_num}, #{second_num}"
    first_num * second_num
end

def multiply_three_sum(expense_counts)
    expense_counts.keys.reduce(nil) do |three_sum_product, expense|
        next three_sum_product if three_sum_product
        expense_counts[expense] -= 1
        two_sum_product = multiply_two_sum(expense_counts, TARGET_SUM - expense)
        expense_counts[expense] += 1
        next nil unless two_sum_product
        puts "multiply_three_sum #{expense}, #{two_sum_product}"
        expense * two_sum_product
    end
end


def get_expense_counts()
    f = File.new("input.txt")
    f.readlines.reduce(Hash.new(0)) { |hash, line| hash.tap { |h| h[line.to_i] += 1 } }
end

# puts multiply_two_sum(get_expense_counts(), TARGET_SUM)
puts multiply_three_sum(get_expense_counts())