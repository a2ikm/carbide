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

  def test_execute_calls_execute_on_each_action
    task = Carbide::Task.new(:task_name)
    context = TestContext.new([])

    action1 = Carbide::Action.new(context) do
      self.value << 42
    end
    task.enhance(action1)

    action2 = Carbide::Action.new(context) do
      self.value << 43
    end
    task.enhance(action2)

    task.execute

    assert_equal [42, 43], context.value
  end

  def test_execute_passes_args_to_each_action
    task = Carbide::Task.new(:task_name)
    context = TestContext.new([])

    action1 = Carbide::Action.new(context) do |arg|
      self.value << arg
    end
    task.enhance(action1)

    action2 = Carbide::Action.new(context) do |arg|
      self.value << arg + 1
    end
    task.enhance(action2)

    task.execute(42)

    assert_equal [42, 43], context.value
  end

  def test_clear_actions
    task = Carbide::Task.new(:task_name)
    context = TestContext.new([])

    action1 = Carbide::Action.new(context) do |arg|
      self.value << arg
    end
    task.enhance(action1)

    action2 = Carbide::Action.new(context) do |arg|
      self.value << arg + 1
    end
    task.enhance(action2)

    task.clear_actions

    assert_equal [], task.actions
  end

  def test_prepend_adds_pre_tasks
    task = Carbide::Task.new(:task_name)
    task1 = Carbide::Task.new(:task_name1)
    task2 = Carbide::Task.new(:task_name2)

    task.prepend([task1, task2])
    assert_equal [task1, task2], task.pre_tasks
  end

  def test_prepend_dont_add_duplicated_pre_tasks
    task = Carbide::Task.new(:task_name)
    task1 = Carbide::Task.new(:task_name1)
    task2 = Carbide::Task.new(:task_name2)

    task.prepend(task1)
    task.prepend([task2, task1])
    assert_equal [task1, task2], task.pre_tasks
  end
end
