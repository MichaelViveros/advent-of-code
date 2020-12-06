# @param group_answers [Array<String>] the group's answers
# @return [Integer] the count of unique answers across all group
# members
def unique_answers_count(group_answers)
  group_answers.reduce([]) do |unique_answers, member_answers|
    unique_answers.union(member_answers.chars)
  end.size
end

# @param group_answers [Array<String>] the group's answers
# @return [Integer] the count of unique answers common to all
# group members
def common_answers_count(group_answers)
  answers = group_answers.first.chars
  group_answers[1..-1].reduce(answers) do |common_answers, member_answers|
    common_answers.intersection(member_answers.chars)
  end.size
end

# input:
# a
# b
# c
#
# ab
# ac
# ...
groups = File.new('input.txt').read.split("\n\n")
             .map { |group_str| group_str.split("\n") }
puts(groups.sum { |g| unique_answers_count(g) })
puts(groups.sum { |g| common_answers_count(g) })
