require "test_helper"

class CarbideTaskTest < Minitest::Test
  def test_name_is_symbol
    task = Carbide::Task.new("task_name")
    assert_equal :task_name, task.name
  end
end
