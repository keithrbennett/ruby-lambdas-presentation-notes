#!/usr/bin/env ruby

# Raw Notes for Ruby Lambdas presentation
# Copyright 2014, Keith R. Bennett

LINE_SEPARATOR = '-' * 79


# Currying - using a function that takes n parameters,
# create a new function that call it, providing some of those
# parameters so that it requires < n parameters
# (e.g. double for mult, square for power below):

# Create a function that will multiply its argument by a number:
mult = ->(multiplier) { ->(n) { multiplier * n } }

# Use it to create a function that will double a number:
double = mult.(2)

puts "double of 3 is #{double.(3)}"

# Similarly, create a function that will raise a number to a power,
# and then a square function that uses it to square a number.
power = ->(exponent) { ->(n) { n ** exponent } }
square = power.(2)
puts "square of 8 is #{square.(8)}"

square_root = power.(0.5)
puts "The square root of 9 is #{ square_root.(9)}"


# Chaining Functions Together

chain = ->(*procs) { ->(x) { procs.inject(x) { |x, proc| proc.(x) } } }
double_then_square = chain.(double, square)
puts "3 doubled then squared is #{double_then_square.(3)}"

add = ->(*numbers) { numbers.inject(:+) }
puts "1 + 2 + 3 = #{add.(1, 2, 3)}"

hypoteneuse = ->(a, b) { square_root.(square.(a) + square.(b)) }
puts "The hypoteneuse of a triangle with sides 3 and 4 is #{hypoteneuse.(3, 4)}"

read_file_lines = ->(filespec) { File.readlines(filespec) }
firster = ->(object) { object.first }
first_line = firster.(read_file_lines.(__FILE__))
puts "#{LINE_SEPARATOR}\nThis script's first line is:\n#{first_line}"

write_file = ->(filespec, contents) { File.write(filespec, contents) }
write_file.('favorites.txt', 'fruit,mango')

parse_csv = ->(string) { string.split(',') }

Favorite = Struct.new(:type, :instance)
parse_favorite = ->(string) {
  fav = Favorite.new
  fav.type, fav.instance = *parse_csv.(string)
  fav
}
puts "#{LINE_SEPARATOR}\nParser parses to: #{parse_favorite.('fruit,mango')}"

format_favorite = ->(favorite) { "Favorite #{favorite.type} is #{favorite.instance}" }

# Putting it all together into a transformation chain:
# Read the first line from the favorites.txt file, parse it
# into a Favorite instance, and apply the formatter to it:

transformations = [
    read_file_lines,
    firster,
    parse_favorite,
    format_favorite
]

transform_chain = chain.(*transformations)
result = transform_chain.('favorites.txt')
puts "#{LINE_SEPARATOR}\nUsing transform chain, we get:\n#{result}."

# Or, more succinctly:
result = chain.(*transformations).('favorites.txt')
puts "#{LINE_SEPARATOR}\nUsing transform chain, we get:\n#{result}."
