#!/usr/bin/env rspec

# Raw Notes for Ruby Lambdas presentation
# Copyright 2014, Keith R. Bennett

require 'rspec'

describe 'Using Lambdas in RSpec' do

  context 'simple' do

    specify 'that dividing by 0 raises an error' do
      # Don't do this!: expect(1 / 0).to raise_error
      expect(-> { 1 / 0 }).to raise_error
    end

    specify 'that dividing by 1 does NOT raise an error' do
      expect(-> { 1 / 1 }).not_to raise_error
    end
  end

  # While extracting the division behavior to this lambda creator
  # is admittedly overkill here, it's shown here to illustrate the
  # concept of extracting common behavior into a single place
  # and using a descriptive name to help the reader better
  # understand:
  #
  # a) that the behaviors of the two are identical,
  #    it's just the data that differs, and
  #
  # b) the nature of the action that is taking place
  #    (by the lambda's name)
  context 'using divides by lambda creator' do
    dividing_by = ->(n) do
      -> { 1 / n }
    end

    specify 'that dividing by 0 raises an error' do
      expect(dividing_by.(0)).to raise_error
    end

    specify 'that dividing by 1 does NOT raise an error' do
      expect(dividing_by.(1)).not_to raise_error
    end

  end
end

