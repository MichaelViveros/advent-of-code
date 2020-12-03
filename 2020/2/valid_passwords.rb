class Password
  attr_accessor :policy_letter, :policy_constraint1, :policy_constraint2, :letter_counts

  def initialize(policy_password_s)
    policy, password = policy_password_s.split(':')
    constraints, @policy_letter = policy.split(' ')
    @policy_constraint1, @policy_constraint2 = constraints.split('-').map(&:to_i)
    @password = password.strip
    @letter_counts = @password.chars.reduce(Hash.new(0)) { |hash, c| hash.tap { |h| h[c] += 1 } }
  end

  def valid1?
    count = @letter_counts[@policy_letter]
    count >= @policy_constraint1 && count <= @policy_constraint2
  end

  def valid2?
    (@password[@policy_constraint1 - 1] == @policy_letter) ^ (@password[@policy_constraint2 - 1] == @policy_letter)
  end
end

f = File.new("input.txt")
passwords = f.readlines.map { |l| Password.new(l) }
puts passwords.count(&:valid1?)
puts passwords.count(&:valid2?)
