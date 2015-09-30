module Carbide
  class Builder
    attr_reader :manager

    def initialize(manager)
      @manager = manager
    end

    def build_task(name, context, &block)
      task = manager[name]
      if task.nil?
        task = Task.new(manager, name)
        manager.register(task)
      end

      if block_given?
        action = Action.new(context, &block)
        task.enhance(action)
      end

      task
    end
  end
end
