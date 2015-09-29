require "test_helper"

class CarbideManagerTest < Minitest::Test
  def test_register_adds_task
    manager = Carbide::Manager.new
    task = Carbide::Task.new(:task_name)

    manager.register(task)

    assert_equal task, manager[task.name]
  end
end
