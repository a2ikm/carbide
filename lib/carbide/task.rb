module Carbide
  class Task
    attr_reader :name, :actions, :pre_tasks

    def initialize(name)
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

    def clear_actions
      actions.clear
      self
    end
  end
end
