module Carbide
  class Action
    attr_reader :context, :block

    def initialize(context, &block)
      @context = context
      @block   = block
    end

    def execute(*args)
      context.instance_exec(*args, &block)
    end
  end
end
