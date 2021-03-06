require "test_helper"

class CarbideTaskTest < Minitest::Test
  def test_name_is_symbol
    manager = Carbide::Manager.new
    task = Carbide::Task.new(manager, "task_name")
    assert_equal :task_name, task.name
  end

  def test_tasks_with_same_name_are_equal
    manager = Carbide::Manager.new
    task_a = Carbide::Task.new(manager, :task_name)
    task_b = Carbide::Task.new(manager, :task_name)
    assert task_a == task_b
  end

  def test_tasks_with_different_names_are_not_equal
    manager = Carbide::Manager.new
    task_a = Carbide::Task.new(manager, :task_name)
    task_b = Carbide::Task.new(manager, :other_task_name)
    assert task_a != task_b
  end

  def test_enhance_adds_action_to_actions
    manager = Carbide::Manager.new
    task = Carbide::Task.new(manager, :task_name)
    context = TestContext.new

    action = Carbide::Action.new(context) do
      # do nothing
    end
    task.enhance(action)

    assert_equal [action], task.actions
  end

  def test_execute_calls_execute_on_each_action
    manager = Carbide::Manager.new
    task = Carbide::Task.new(manager, :task_name)
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
    manager = Carbide::Manager.new
    task = Carbide::Task.new(manager, :task_name)
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
    manager = Carbide::Manager.new
    task = Carbide::Task.new(manager, :task_name)
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

  def test_clear_pre_tasks
    manager = Carbide::Manager.new
    task = Carbide::Task.new(manager, :task_name)
    pre_task = Carbide::Task.new(manager, :pre_task_name)
    task.prepend(pre_task)

    task.clear_pre_tasks

    assert_equal [], task.pre_tasks
  end

  def test_clear_post_tasks
    manager = Carbide::Manager.new
    task = Carbide::Task.new(manager, :task_name)
    post_task = Carbide::Task.new(manager, :post_task_name)
    task.append(post_task)

    task.clear_post_tasks

    assert_equal [], task.post_tasks
  end

  def test_prepend_adds_pre_tasks
    manager = Carbide::Manager.new
    task = Carbide::Task.new(manager, :task_name)
    task1 = Carbide::Task.new(manager, :task_name1)
    task2 = Carbide::Task.new(manager, :task_name2)

    task.prepend([task1, task2])
    assert_equal [:task_name1, :task_name2], task.pre_tasks
  end

  def test_prepend_dont_add_duplicated_pre_tasks
    manager = Carbide::Manager.new
    task = Carbide::Task.new(manager, :task_name)
    task1 = Carbide::Task.new(manager, :task_name1)
    task2 = Carbide::Task.new(manager, :task_name2)

    task.prepend(task1)
    task.prepend([task2, task1])
    assert_equal [:task_name1, :task_name2], task.pre_tasks
  end

  def test_append_adds_post_tasks
    manager = Carbide::Manager.new
    task = Carbide::Task.new(manager, :task_name)
    task1 = Carbide::Task.new(manager, :task_name1)
    task2 = Carbide::Task.new(manager, :task_name2)

    task.append([task1, task2])
    assert_equal [:task_name1, :task_name2], task.post_tasks
  end

  def test_append_dont_add_duplicated_post_tasks
    manager = Carbide::Manager.new
    task = Carbide::Task.new(manager, :task_name)
    task1 = Carbide::Task.new(manager, :task_name1)
    task2 = Carbide::Task.new(manager, :task_name2)

    task.append(task1)
    task.append([task2, task1])
    assert_equal [:task_name1, :task_name2], task.post_tasks
  end

  def test_invoke
    manager = Carbide::Manager.new
    context = TestContext.new([])

    task = Carbide::Task.new(manager, :task_name)
    manager.register(task)
    action = Carbide::Action.new(context) do
      self.value << :main
    end
    task.enhance(action)

    task1 = Carbide::Task.new(manager, :task_name1)
    manager.register(task1)
    action1 = Carbide::Action.new(context) do
      self.value << :pre
    end
    task1.enhance(action1)
    task.prepend(task1)

    task2 = Carbide::Task.new(manager, :task_name2)
    manager.register(task2)
    action2 = Carbide::Action.new(context) do
      self.value << :post
    end
    task2.enhance(action2)
    task.append(task2)

    task.invoke
    assert_equal [:pre, :main, :post], context.value
  end
end
