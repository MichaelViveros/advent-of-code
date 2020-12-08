# store luggages in a doubly linked list

# @attr_reader [String] colour the colour
# @attr [Array<Node>] contains the luggages I contain
# @attr [Array<Node>] contained_in the luggages I am contained in
class Luggage
  attr_reader :colour, :contains
  attr_accessor :contained_in
  def initialize(colour, contains = [])
    @colour = colour
    self.contains = contains
    @contained_in = []
  end

  def contains=(val)
    @contains = val
    val.each { |l| l.contained_in << self }
  end

  # 1 - 2 - 4
  #   \     |
  #    3    |
  #         5
  # do a depth-first search to find the furthest luggage
  # you are contained in, add it, move back a step to its 
  # contains, add it, ...
  # TODO: keep track of visited luggages
  def contained_in_all
    return [] unless @contained_in

    @contained_in.flat_map { |l| l.contained_in_all << l }
  end

  def to_s
    "Luggage - #{@colour}, contains - #{@contains.map(&:colour)},
    contained_in #{@contained_in.map(&:colour)}"
  end
end

@l_blue = Luggage.new(
  'blue',
  [Luggage.new('red', [Luggage.new('white', [])])]
)
@l_red = @l_blue.contains.first
@l_white = @l_red.contains.first
puts @l_white.contained_in_all

f = File.new('input.txt')
colour_regex = /^([[:alpha:]]+ [[:alpha:]]+) bags contain /
# contains_regex = /([[:digit:]]+) ([[:alpha:]]+ [[:alpha:]]+) bags?,? ?/
contains_regex = /[[:digit:]]+ ([[:alpha:]]+ [[:alpha:]]+) bags?,? ?/
no_contains_regex = /contain no other bags/
@luggages_hash = f.readlines.each_with_object({}) do |line, hash|
  next if no_contains_regex.match(line)

  colour = line.scan(colour_regex).flatten.first
  contains_colours = line.scan(contains_regex).flatten
  puts "LINE #{line}"
  puts "colour #{colour}"
  puts "contains_colours #{contains_colours}"
  contains_luggages = contains_colours.map do |c|
    if hash.key?(c)
      hash[c]
    else
      luggage = Luggage.new(c)
      hash[c] = luggage
    end
  end
  puts "contains_luggages #{contains_luggages.map(&:to_s)}"
  if hash.key?(colour)
    hash[colour].contains = contains_luggages
  else
    hash[colour] = Luggage.new(colour, contains_luggages)
  end
end
puts 'luggages_hash'
@luggages_hash.each { |k, v| puts "#{k} #{v}" }
puts @luggages_hash['shiny gold'].contained_in_all
                                 .map(&:colour).uniq.count
