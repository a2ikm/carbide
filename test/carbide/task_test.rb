require "test_helper"

class CarbideTaskTest < Minitest::Test
  def test_name_is_symbol
    task = Carbide::Task.new("task_name")
    assert_equal :task_name, task.name
  end

  def test_enhance_adds_action_to_actions
    task = Carbide::Task.new(:task_name)
    context = TestContext.new

    action = Carbide::Action.new(context) do
      # do nothing
    end
    task.enhance(action)

    assert_equal [action], task.actions
  end
end
