module Carbide
  class Task
    attr_reader :manager, :name, :actions, :pre_tasks, :post_tasks

    def initialize(manager, name)
      @manager    = manager
      @name       = name.to_sym
      @actions    = []
      @pre_tasks  = []
      @post_tasks = []
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

    def append(tasks)
      @post_tasks |= Array(tasks).map(&:name)
      self
    end

    def execute(*args)
      actions.each do |action|
        action.execute(*args)
      end
      self
    end

    def invoke(*args)
      invoke_pre_tasks(*args)
      execute(*args)
      invoke_post_tasks(*args)
      self
    end

    def invoke_pre_tasks(*args)
      pre_tasks.each do |pre_task|
        task = manager[pre_task]
        task.invoke(*args)
      end
      self
    end

    def invoke_post_tasks(*args)
      post_tasks.each do |post_task|
        task = manager[post_task]
        task.invoke(*args)
      end
      self
    end

    def clear_actions
      actions.clear
      self
    end

    def clear_pre_tasks
      pre_tasks.clear
      self
    end

    def clear_post_tasks
      post_tasks.clear
      self
    end

    def clear
      clear_actions
      clear_pre_tasks
      clear_post_tasks
      self
    end
  end
end
