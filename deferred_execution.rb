# Raw Notes for Ruby Lambdas presentation
# Copyright 2014, Keith R. Bennett

# Let's create an array of lambdas that require no context (params):
actions = [
    ->() { puts 1 },
    ->() { puts 2 }
]

# Then let's write a method that will call them:

def run_them(actions)
  actions.each { |action| action.() }  # or action.call

  # or, more simply, given that the lambdas take no arguments::
  # actions.each(&:call)
end


# Now, let's illustrate how we could use this deferred execution
# to inject behavior into the initialization of an object.
# We'll define a couple of lambdas that take
# the newly initialized object as a parameter.
actions = [
    ->(object) { puts "#{object}" },
    ->(object) { puts "Initialized at #{object.init_time}" }
]

# ...and then define a class that performs its own initialization,
# then calls the passed lambdas:

class MyFramework_2

  attr_reader :init_time

  def initialize(actions)
    @init_time = Time.now
    # ... initialization stuff...
    actions.each { |action| action.(self) }
  end
end


framework = MyFramework_2.new(actions)




