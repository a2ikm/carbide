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

      name = name.to_sym
      task = carbide_manager[name]
      if task.nil?
        task = Task.new(name)
        carbide_manager.register(task)
      end

      if block_given?
        action = Action.new(self, &block)
        task.enhance(action)
      end

      task
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
