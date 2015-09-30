module Carbide
  class ManagerUnavailable < StandardError
    def initialize(klass)
      message = "#{klass.name} doesn't respond to carbide_manager or " \
                "its return value isn't a Carbide::Manager."
      super(message)
    end
  end

  module DSL
    def invoke(name, *args)
      verify_carbide_manager_available

      task = carbide_manager[name]
      if task
        task.execute(*args)
      end
    end

    def task(name, &block)
      verify_carbide_manager_available
      Builder.new(carbide_manager).build_task(name, self, &block)
    end

    def before_task(name, pre_name, &block)
      verify_carbide_manager_available
      Builder.new(carbide_manager).build_pre_task(name, pre_name, self, &block)
    end

    def after_task(name, post_name, &block)
      verify_carbide_manager_available
      Builder.new(carbide_manager).build_post_task(name, post_name, self, &block)
    end

    private

    def verify_carbide_manager_available
      if !respond_to?(:carbide_manager) ||
          !carbide_manager.is_a?(Carbide::Manager)
        raise ManagerUnavailable.new(self.class)
      end
    end
  end
end
