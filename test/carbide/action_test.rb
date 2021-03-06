require "test_helper"

class CarbideActionTest < Minitest::Test
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

  def test_throwing_break_stops_executing_block
    context = TestContext.new
    context.value = 42

    action = Carbide::Action.new(context) do
      throw :break
      self.value = 43
    end
    action.execute

    assert_equal 42, context.value
  end
end
