module Carbide
  class Task
    attr_reader :name

    def initialize(name)
      @name = name.to_sym
    end

    alias to_sym name
  end
end
