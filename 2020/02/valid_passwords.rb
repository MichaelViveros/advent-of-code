class Password
  attr_reader :policy_letter, :policy_constraint1,
              :policy_constraint2, :letter_counts

  def initialize(policy_password_s)
    # Ex. "1-8 n: dpwpmhknmnlglhjtrbpx"
    regex = /([[:digit:]]+)\-([[:digit:]]+) ([[:alpha:]]): ([[:alpha:]]+)/
    match = regex.match(policy_password_s)
    @policy_constraint1 = match[1].to_i
    @policy_constraint2 = match[2].to_i
    @policy_letter = match[3]
    @password = match[4]
    @letter_count = @password.count(@policy_letter)
  end

  def valid1?
    @letter_count >= @policy_constraint1 &&
      @letter_count <= @policy_constraint2
  end

  def valid2?
    (@password[@policy_constraint1 - 1] == @policy_letter) ^
      (@password[@policy_constraint2 - 1] == @policy_letter)
  end
end

# input:
# 1-8 n: dpwpmhknmnlglhjtrbpx
# 11-12 n: frpknnndpntnncnnnnn
# 4-8 t: tmttdtnttkr
f = File.new('input.txt')
passwords = f.readlines.map { |l| Password.new(l) }
puts passwords.count(&:valid1?)
puts passwords.count(&:valid2?)
