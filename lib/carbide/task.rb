module Carbide
  class Task
    attr_reader :name, :actions

    def initialize(name)
      @name    = name.to_sym
      @actions = []
    end

    alias to_sym name

    def enhance(action)
      actions << action
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
