$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'carbide'

require 'minitest/autorun'

class TestContext
  attr_accessor :value

  def initialize(value = nil)
    @value = value
  end
end
