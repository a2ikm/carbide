require "test_helper"

class TestCarbided
  include Carbide::DSL

  attr_accessor :value

  def initialize(value = nil)
    @value = value
    define_tasks
  end

  def define_tasks
  end

  def carbide_manager
    @carbide_manager ||= Carbide::Manager.new
  end
end

class CarbideDSLTest < Minitest::Test
  def test_task_verifies_carbide_manager_is_available
    klass = Class.new(TestCarbided) do
      def define_tasks
        task :task_name
      end

      def carbide_manager
        nil
      end
    end

    assert_raises Carbide::ManagerUnavailable do
      klass.new
    end
  end

  def test_task_defines_task_without_action
    carbided = Class.new(TestCarbided) do
      def define_tasks
        task :task_name
      end
    end.new

    task = carbided.carbide_manager[:task_name]
    assert_kind_of Carbide::Task, task
    assert_equal [], task.actions
  end

  def test_task_defines_task_with_action
    carbided = Class.new(TestCarbided) do
      def define_tasks
        task :task_name do
          self.value = 42
        end
      end
    end.new

    task = carbided.carbide_manager[:task_name]
    assert_equal 1, task.actions.count

    task.execute
    assert_equal 42, carbided.value
  end

  def test_task_adds_action_to_defined_task
    carbided = Class.new(TestCarbided) do
      def define_tasks
        task :task_name do
          self.value << 42
        end
        task :task_name do
          self.value << 43
        end
      end
    end.new([])

    task = carbided.carbide_manager[:task_name]
    task.execute
    assert_equal [42, 43], carbided.value
  end

  def test_invoke_executes_task
    carbided = Class.new(TestCarbided) do
      def define_tasks
        task :task_name do |arg|
          self.value = arg
        end
      end

      def run
        invoke(:task_name, 42)
      end
    end.new

    carbided.run
    assert_equal 42, carbided.value
  end
end
