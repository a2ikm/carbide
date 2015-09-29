module Carbide
  module DSL
    def invoke(name, *args)
      task = carbide_manager[name]
      if task
        task.execute(*args)
      end
    end

    def task(name, &block)
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
  end
end