# Raw Notes for Ruby Lambdas presentation
# Copyright 2014, Keith R. Bennett

# A predicate is something that returns a true or false value.

# Simplest case:
->() { true }
->() { false }

# Taking 1 parameter:
is_even = ->(n) { n % 2 == 0 }
is_even.(22)  # => true
is_even.(23)  # => false


# Taking 2 parameters:
greater_than = ->(x, y) { x > y }
greater_than.(3, 2)  # => true
greater_than.(2, 2)  # => false
greater_than.(1, 2)  # => false


greater_than_generator = ->(threshold) do
  ->(n) { n > threshold }
end

greater_than_100 = greater_than_generator.(100)


is_multiple_of_generator = ->(factor) do
  ->(n) { n % factor == 0 }
end

is_multiple_of_55 = is_multiple_of_generator.(55)

# Let's assemble is_even, greater_than_100, and is_multiple_of_3
# into a single 'compound' predicate.
compound_predicate = ->(n) do
  is_even(n) && greater_than_100(n) && is_multiple_of_55(n)
end

# Ruby's super amazing Enumerable module's methods enables us
# to separate the comparison implementations from the process
# of combining them:

my_predicates = [is_even, greater_than_100, is_multiple_of_55]

my_all_predicate_1 = ->(n) do
  my_predicates.all? { |p| p.(n) }
end


# Are you seeing a pattern here?  We can create a lambda that
# returns a compound predicate:
all = ->(predicates) do
  ->(n) { predicates.all? { |p| p.(n) } }
end

my_all_predicate_2 = all.(my_predicates)

# Let's (somewhat) verify that the 2 implementations behave the same:
(0..10_000).each do |n|
  raise "Mismatch on #{n}" if my_all_predicate_1.(n) != my_all_predicate_2.(n)
end

# Now, let's print out the numbers for which the compound predicate is true,
# in the range 0 to 1_000:
results = (0..1_000).select { |n| my_all_predicate_1.(n) }
puts 'All:  ' + results.join(', ')
# # All: 110, 220, 330, 440, 550, 660, 770, 880, 990


# Similarly, we can assemble compound predicates for 'any':

any = ->(predicates) do
  ->(n) { predicates.any? { |p| p.(n) } }
end

my_any_predicate = any.(my_predicates)
results = (0..1_000).to_a.select { |n| my_any_predicate.(n) }
puts "Any:  #{results.take(10).join(', ')}..."
# Any: 0, 2, 4, 6, 8, 10, 12, 14, 16, 18...


# Similarly, we can assemble compound predicates for 'none':

none = ->(predicates) do
  ->(n) { predicates.none? { |p| p.(n) } }
end
my_none_predicate = none.(my_predicates)
results = (0..1_000).to_a.select { |n| my_none_predicate.(n) }
puts "None: #{results.take(10).join(', ')}..."
# None: 1, 3, 5, 7, 9, 11, 13, 15, 17, 19...

# Think: How would you put together a similarly flexible
# predicate framework without lambdas?  To what extent
# would duck typing help?

