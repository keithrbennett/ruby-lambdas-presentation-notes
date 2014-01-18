# Raw Notes for Ruby Lambdas presentation
# Copyright 2014, Keith R. Bennett

# Using this approach will make it trivially easy to extract a method
# into a standalone class.  In contrast, the monolithic approach does
# nothing to help, and the methods approach requires finding all
# necessary methods, and ensuring that they are not needed by
# methods other than this one.

class SampleUsingLambdas

  def task_1

    validate_inputs = ->() do
      # ----------------
      # ----------------
      # ----------------
      # ----------------
    end

    perform = ->() do
      # ----------------
      # ----------------
      # ----------------
      # ----------------
    end

    cleanup = ->() do
      # ----------------
      # ----------------
      # ----------------
      # ----------------
    end

    validate_inputs.()
    perform.()
    cleanup.()
  end


  def task_2

    validate_inputs = ->() do
      # ----------------
      # ----------------
      # ----------------
      # ----------------
    end

    perform = ->() do
      # ----------------
      # ----------------
      # ----------------
      # ----------------
    end

    cleanup = ->() do
      # ----------------
      # ----------------
      # ----------------
      # ----------------
    end

    validate_inputs.()
    perform.()
    cleanup.()
  end


  def task_3

    validate_inputs = ->() do
      # ----------------
      # ----------------
      # ----------------
      # ----------------
    end

    perform = ->() do
      # ----------------
      # ----------------
      # ----------------
      # ----------------
    end

    cleanup = ->() do
      # ----------------
      # ----------------
      # ----------------
      # ----------------
    end

    validate_inputs.()
    perform.()
    cleanup.()
  end



end
