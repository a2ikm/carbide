require "test_helper"

class CarbideActionTest < Minitest::Test
  class TestContext
    attr_accessor :value
  end

  def test_execute_block_within_context
    context = TestContext.new

    action = Carbide::Action.new(context) do
      self.value = 42
    end
    action.execute

    assert_equal 42, context.value
  end

  def test_execute_pass_args_to_block
    context = TestContext.new

    action = Carbide::Action.new(context) do |arg|
      self.value = arg
    end
    action.execute(42)

    assert_equal 42, context.value
  end

  def test_execute_can_refer_variables_outside_of_block
    context = TestContext.new

    var = 42
    action = Carbide::Action.new(context) do
      self.value = var
    end
    action.execute

    assert_equal 42, context.value
  end

  def test_execute_can_change_variables_outside_of_block
    context = TestContext.new

    var = 42
    action = Carbide::Action.new(context) do
      var += 1
    end
    action.execute

    assert_equal 43, var
  end
end
