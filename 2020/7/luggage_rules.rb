# store luggages in a doubly linked list

# @attr_reader [String] colour the colour
# @attr [Array<Node>] contains the luggages I contain
# @attr [Array<Integer>] contains_quantities the quantities of each
# luggage I contain
# @attr [Array<Node>] contained_in the luggages I am contained in
class Luggage
  attr_reader :colour, :contains
  # TODO: think of cleaner way to track contains_quantities
  attr_accessor :contained_in, :contains_quantities
  def initialize(colour, contains = [], contains_quantities = [])
    @colour = colour
    self.contains = contains
    @contains_quantities = contains_quantities
    @contained_in = []
  end

  def contains=(val)
    @contains = val
    val.each { |luggage| luggage.contained_in << self }
  end

  # do a depth-first search to find the furthest luggage
  # you are contained in, add it, move back a step to its 
  # contains, add it, ...
  # TODO: keep track of visited luggages to avoid .uniq
  def contained_in_all
    return [] unless @contained_in

    @contained_in.flat_map { |l| l.contained_in_all << l }
  end

  # do a depth-first search to get the furthest luggage contained
  # within you, add it and its contains, move back a step to its
  # contained_in
  #
  # similar algo to contained_in_all but moving to the right
  # (through contains) as opposed to to the left (through
  # contained_in)
  def contains_count
    @contains.each_with_index.reduce(0) do |count, (luggage, i)|
      quantity = @contains_quantities[i]
      count + quantity + quantity * luggage.contains_count
    end
  end

  def to_s
    "Luggage - #{@colour}, contains - #{@contains.map(&:colour)},
    contained_in #{@contained_in.map(&:colour)}"
  end
end

f = File.new('input.txt')
# Ex. line - 'vibrant lime bags contain 3 faded gold bags, 
# 3 plaid aqua bags, 2 clear black bags.'
# colour -> 'vibrant lime'
colour_regex = /^([[:alpha:]]+ [[:alpha:]]+) bags contain /
# contains -> [[3, 'faded gold'], [3, 'plaid agua'], [2, 'clear black']]
contains_regex = /([[:digit:]]+) ([[:alpha:]]+ [[:alpha:]]+) bags?,? ?/
no_contains_regex = /contain no other bags/
# build up a hash of luggages to allow for quick look-ups when
# creating luggages
# TODO: cleanup this parsing shit show
@luggages_hash = f.readlines.each_with_object({}) do |line, hash|
  next if no_contains_regex.match(line)

  luggage_colour = line.scan(colour_regex).flatten.first
  contains = line.scan(contains_regex)
  contains_luggages = contains.map do |(_quantity, colour)|
    if hash.key?(colour)
      hash[colour]
    else
      luggage = Luggage.new(colour)
      hash[colour] = luggage
    end
  end
  contains_quantities = contains.map { |(quantity, _)| quantity.to_i }
  if hash.key?(luggage_colour)
    luggage = hash[luggage_colour]
    luggage.contains = contains_luggages
    luggage.contains_quantities = contains_quantities
  else
    hash[luggage_colour] = Luggage.new(
      luggage_colour,
      contains_luggages,
      contains_quantities
    )
  end
end
gold = @luggages_hash['shiny gold']
contained_in_all = gold.contained_in_all
puts contained_in_all.map(&:colour).uniq.count
puts gold.contains_count
