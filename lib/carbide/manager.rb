module Carbide
  class Manager
    attr_reader :tasks

    def initialize
      @tasks = {}
    end

    def [](name)
      tasks[name.to_sym]
    end

    def []=(name, task)
      tasks[name.to_sym] = task
    end

    def register(task)
      self[task.name] = task
    end
  end
end
