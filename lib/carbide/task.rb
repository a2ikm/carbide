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
  end
end
