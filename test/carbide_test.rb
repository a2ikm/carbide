require "test_helper"

class CarbideTest < Minitest::Test
  class CarbideTestWithNoOptions < self
    def carbided
      @carbided ||= Class.new do
        include Carbide
        carbide

        def carbide_manager
          @carbide_manager ||= Carbide::Manager.new
        end
      end.new
    end

    def test_invoke_is_defined
      assert_respond_to carbided, :invoke
    end

    def test_task_is_defined
      assert_respond_to carbided, :task
    end

    def test_before_is_defined
      assert_respond_to carbided, :before
    end

    def test_after_is_defined
      assert_respond_to carbided, :after
    end

    def test_task_defines_task
      carbided.task :task_name do |v|
        v << :some_value
      end

      assert_equal 1, carbided.carbide_manager.tasks.count

      value = []
      carbided.invoke(:task_name, value)
      assert_equal [:some_value], value
    end

    def test_before_defines_pre_task
      carbided.task :task_name do |v|
        v << :some_value
      end
      carbided.before :task_name, :pre_task_name do |v|
        v << :pre_value
      end

      assert_equal 2, carbided.carbide_manager.tasks.count

      value = []
      carbided.invoke(:task_name, value)
      assert_equal [:pre_value, :some_value], value
    end

    def test_after_defines_post_task
      carbided.task :task_name do |v|
        v << :some_value
      end
      carbided.after :task_name, :post_task_name do |v|
        v << :post_value
      end

      assert_equal 2, carbided.carbide_manager.tasks.count

      value = []
      carbided.invoke(:task_name, value)
      assert_equal [:some_value, :post_value], value
    end
  end

  class CarbideTestWithManagerOption < self
    def carbided
      @carbided ||= Class.new do
        include Carbide
        carbide manager: :@carbide_manager

        def initialize
          @carbide_manager = Carbide::Manager.new
        end
      end.new
    end

    def test_task_defines_task
      carbided.task :task_name do |v|
        v << :some_value
      end

      value = []
      carbided.invoke(:task_name, value)
      assert_equal [:some_value], value
    end
  end

  class CarbideTestWithPrefixOption < self
    def carbided
      @carbided ||= Class.new do
        include Carbide
        carbide prefix: :foo

        def carbide_manager
          @carbide_manager ||= Carbide::Manager.new
        end
      end.new
    end

    def test_invoke_with_prefix_is_defined
      assert_respond_to carbided, :foo_invoke
    end

    def test_task_with_prefix_is_defined
      assert_respond_to carbided, :foo_task
    end

    def test_before_with_prefix_is_defined
      assert_respond_to carbided, :foo_before
    end

    def test_after_with_prefix_is_defined
      assert_respond_to carbided, :foo_after
    end
  end
end
