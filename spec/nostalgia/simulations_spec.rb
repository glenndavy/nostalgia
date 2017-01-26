require 'spec_helper'

describe Nostalgia::Simulations do
  it "should respond to simulate" do
    Nostalgia::Simulations.respond_to?(:simulate).must_equal true
  end
end

