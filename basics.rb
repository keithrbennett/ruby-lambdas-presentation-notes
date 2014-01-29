# Raw Notes for Ruby Lambdas presentation
# Copyright 2014, Keith R. Bennett

# ----

"
Our quest and our mission as software developers is to tame complexity, to simplify ruthlessly.
"

"
OOD is powerful for organizing behavior, but without lambdas' code-as-data flexibility,
fails to reduce solutions to their simplest form.
"

"
Lambda use is a complement to OOD, not a substitute for it.
"

# ----


# ----

"
I am not a functional programming expert; the material I present today
is based on my very limited experience with Erlang and Clojure,
and more recent exploration in Ruby.
"

# ----

"
A lambda is a free floating function; it does not belong to, or
is even associated with, an object or class.
"

# ----

# A lambda that takes no parameters, does nothing, and returns nothing:

# Original pre-1.9 notation:

lambda {}
lambda do
end

# With parameters:
lambda { |param1, param2| }
lambda do |param1, param2|
end


# >= 1.9 notation:
->{}       # if no params
-> do end  # if no params

# With parameters:
->(params) {}
->(params) do
end



# ----

# Calling a lambda:
my_lambda = ->{}
my_lambda.call  # all versions
my_lambda[]     # all versions
my_lambda.()    # >= 1.9


# ----

# We normally assign lambdas to variables...
nothing_doer = -> {}

# and/or pass them to methods...
# add_action(-> {})
# add_action(nothing_doer)

# but nothing stops us from calling them directly:
->{}.call
->{}.()
lambda {}.call
lambda {}.()

# This approach would usually not make sense, but
# could be used, for example, to avoid adding
# any constant or variable names to the current binding.

# ----

# Here's a lambda that always returns true:
-> { true }

# Let's assign it to a variable:
always_true =  -> { true }

# ...and call it:
always_true.()   # => true
always_true.call # => true
always_true[]    # => true

# ----

# Now let's define a lambda that will take a parameter...

# An even number tester lambda:
->(n) { n % 2 == 0 }

# You could say that ->(n) is "a lambda that is called with a parameter n".

is_even = ->(n) { n % 2 == 0 }
is_even.(10) # => true
is_even.(11) # => false

# ----

# A lambda that returns the number doubled:
double = ->(n) { 2 * n }
double.(12)  # => 24

# ...and triple, and quadruple:
triple    = ->(n) { 3 * n }
quadruple = ->(n) { 4 * n }

# see the duplication? Let's separate the logic from the data
# by creating a function that provides the logic and returns
# a lambda prefilled with the multiplier.

# ----

# Pattern: Partial Application

# Using partial application to fill variables into a lambda:

# Returns a lambda that, when called with a number,
# will return the specified multiple of that number.

# Using a method that returns a lambda:
def fn_multiply_by(factor)
  ->(n) { factor * n }
end

tripler = fn_multiply_by(3) # => #<Proc:0x007f9c1c11aa70@(irb):13 (lambda)>
tripler.(123)  # => 369

# ...or a lambda that returns a lambda:

fn_multiply_by = ->(factor) do
  ->(n) { factor * n }
end

tripler = fn_multiply_by.(3) # => #<Proc:0x007f9c1c11aa70@(irb):13 (lambda)>
tripler.(123)  # => 369

quadrupler = fn_multiply_by.(4) # => #<Proc:0x007f9c1c1056c0@(irb):18 (lambda)>
quadrupler.(8)  # => 32

# ----

# Pattern: Partial Application
# Let's go back to the is_even.

# How would you generalize it so that the logic is in a place
# that can be shared by calculators of multiples of any number?

fn_multiple_of = ->(m) { ->(n) { n % m == 0 } }
is_even = fn_multiple_of.(2)
is_even.(10) # => true
is_even.(11) # => false

# ----

# Pattern: Currying

# Currying is like partial application, but works a little differently.
# Ruby's Proc class has a curry method that can be applied:

multiply_2_numbers = ->(x, y) { x * y }
tripler = multiply_2_numbers.curry[3]
tripler.(7) # => 21


# ----

# Separating Data from Behavior & Deferred Execution

# I have a TextModeStatusUpdater class used for text only terminals
# that uses ANSI escape sequences to clear the line, go to its beginning,
# and print a status message.
#
# Its 'print' method is called at fixed intervals by other code.
# In order to know what to print, you pass it a lambda:

# text_generator = ->() { "%9.3f   %9.3f" % [time_elapsed, time_to_go] }
# status_updater = TextModeStatusUpdater.new(text_generator, $stderr)

# ----

# Pattern: Action / Runtime Context Split

# Another example, this one separating the exit condition (predicate)
# from the mechanics with which it is used:

# Calls a predicate proc repeatedly, sleeping the specified interval
# between calls, and giving up after the specified number of seconds.
# Displays elapsed and remaining times on the terminal.
#
# Returns true if the operation succeeded (i.e. the predicate returned true
# on the first try or a subsequent try), else returns false (after
# having tried until the timeout expired).
def retry_until_true_or_timeout(
    predicate, sleep_interval, timeout_secs, output_stream = $stdout)
end

server_response_succeeded = -> { } # condition code goes here
success = retry_until_true_or_timeout(server_response_succeeded, 0.2, 30)

# ----

# Patterns: Repeated Use Within Function, Nested Function

# Performing the same operation multiple times in a method:

def setup

  load_string = ->(filespec) do
    # ....
    # returns the loaded and processed string
  end

  @red_string    = load_string.('red.txt')
  @blue_string   = load_string.('blue.txt')
  @yellow_string = load_string.('yellow.txt')
end

# ----

# Pattern: Command

# Your class may need configurable behaviors.
# They could be in the form of a hash
# with symbols as keys and lambdas as values:

event_handlers = {
    blue_event:   ->(event) { do_something_with(event) },
    red_event:    ->(event) { do_something_else_with(event) },
    yellow_event: ->(event) { do_something_different_with(event) },
}

class C
  attr_accessor :event_handlers

  # @param responses a hash containing event type symbols
  #                  and their corresponding actions
  def initialize(event_handlers)
    event_handlers = event_handlers
  end

  def run
    #loop do
    #  event = event_queue.read
    #  responses[event.code].(event)
    #end
  end
end

c = C.new(event_handlers).run

# ----

# Lambdas are Closures:

# This can be good:

n = 15
-> { puts n }.()
# 15


# This can be bad:

n = 15
-> { n = "I just overwrote n." }.()
puts n
# I just overwrote n.

# ----

# Using Lambdas with RSpec

# (see lambda_expectations_spec.rb)

# ----

# Using Lambdas to Simplify RSpec Code

test = ->(method_name, expected_value) do
  specify "expect #{method_name} to return the value from the original text" do
    expect(subject.send(method_name)).to eq(expected_value)
  end
end

test.(:foo, 23032)
test.(:bar, 2)
test.(:baz, 79090)


# ----

# Using Lambdas to Organize Your Code

# (see inner functions files)

# ----

# Enumerables

[1,2,3].map { |n| quadrupler.(n) }   # => [4, 8, 12]

# Shorthand:
[1,2,3].map(&quadrupler)   # => [4, 8, 12]

# ----

# Similarly, we can create a lambda that will raise
# a number to the n'th power:
fn_power_raiser = ->(power) do
  ->(n) { n ** power }
end

# Note: It's easier to understand if you read from the inside out.
# (n)                  signature
# { n ** power }       body
# ->(n) { n ** power } complete lambda that is returned
# the entire fn_power_raiser method

# ----

squarer = fn_power_raiser.(2)
squarer.(4)  # => 16

cuber = fn_power_raiser.(3)
cuber.(3)  # => 27

tripler = ->(n) { 3 * n }

# ----

# Pattern: Transform Chain

# Creating a Transform Chain Using Enumerables

# Lambdas are first class objects just like strings, hashes, and regexes,
# so you can store them in an array:
my_transforms = [tripler, squarer]

# Returns a lambda that takes an object as input and
# applies the specified transforms to it, returning the result.
fn_compound_transform = ->(transforms) do
  ->(x) do
    transforms.inject(x) { |t, accumulator| accumulator.(t) }
  end
end

tripler_and_squarer = fn_compound_transform.(my_transforms)
tripler_and_squarer.(4)  # => 144

# ----

# Using a Lambda Where a Code Block is Expected

# If you have a lambda, you can make it look like a code block
# to the called function using '&':

# Some logging frameworks support the passing of code blocks so
# that potentially expensive message building can be done only when
# that message will be written:

class MyLogger
  def info(object = nil)
    if block_given?
      puts("Code block: #{yield}")
    else
      puts object
    end
  end
end

MyLogger.new.info('I am a string')           # "I am a string"
MyLogger.new.info { 'I am inside a block' }  # "Code block: I am inside a block"

proclaimer = -> { 'I am inside a lambda' }
MyLogger.new.info(&proclaimer)               # "Code block: I am inside a lambda"

# ----

# Classes can be defined in a lambda, but cannot be defined in a method:

-> { class C; end }.()
# => nil
>   C.new
# => #<C:0x007ffe728ccf08>

def create_class
  class C; end
end
# SyntaxError: (irb):103: class definition in method body
# class C; end
# ^

# Used this in an RSpec test of a validation method
# that ensured that the specified set
# of instance variables in an object were not nil.

# ----
# Returning

# A lambda's return returns from itself, and not
# the enclosing method or lambda:
def foo
  -> { return }.()
  puts "still in foo"
end

# > foo
# still in foo

# A proc's return returns from its enclosing method or lambda:
def foo
  proc { return }.()
  puts "still in foo"
end
nil

foo
# > (no output)

# ----

# Lambdas have strict argument checking; procs do not:

two_arg_lambda = ->(a, b) {}
two_arg_lambda.(1)
# ArgumentError: wrong number of arguments (1 for 2)
#  from (irb):15:in `block in irb_binding'
#  from (irb):15:in `call'
#  from (irb):15
#  from /Users/kbennett/.rvm/rubies/ruby-1.9.3-p448/bin/irb:16:in `<main>'

two_arg_proc = proc { |a, b| }
two_arg_proc.(1)
# nil

# ----

# Arity

# We can find out the arity of a lambda (really, any Proc)
# by calling its 'arity' method:
is_even.arity  # => 1

# The arity is the number of required parameters:
->(a, b=0) {}.arity # => 1

# If there is a splat parameter, the number returned will be negative:
->(*a) {}.arity     # => -1
->(x, *a) {}.arity  # => -2

# ----

# Methods as Lambdas

# It's possible to create a lambda based on a method:
def foo(a, b)
  puts a
  puts b
end

fn = lambda(&method(:foo))
fn.('Hello', 'World')

# Hello
# World

# ----

# Even though a lambda is an instance of class Proc,
# calling self will not return that instance;
# instead it will return its enclosing object,
# which, in the case of pry and irb, is 'main'.

# Lambdas:

-> { puts self }.()
# main


# Procs:

(proc { puts self }).()
# main

# ----

# Predicates

# see predicates.rb

