module Carbide
  class Task
    attr_reader :manager, :name, :actions, :pre_tasks

    def initialize(manager, name)
      @manager   = manager
      @name      = name.to_sym
      @actions   = []
      @pre_tasks = []
    end

    alias to_sym name

    def ==(other)
      self.class === other &&
        name == other.name
    end

    def enhance(action)
      actions << action
      self
    end

    def prepend(tasks)
      @pre_tasks |= Array(tasks).map(&:name)
      self
    end

    def execute(*args)
      actions.each do |action|
        action.execute(*args)
      end
      self
    end

    def invoke_pre_tasks(*args)
      pre_tasks.each do |pre_task|
        task = manager[pre_task]
        task.invoke(*args)
      end
      self
    end

    def clear_actions
      actions.clear
      self
    end
  end
end
