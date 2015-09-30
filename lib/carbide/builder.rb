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

    def build_pre_task(name, pre_name, context, &block)
      pre_task = manager[pre_name]
      if pre_task.nil?
        pre_task = Task.new(manager, pre_name)
        manager.register(pre_task)
      end

      if block_given?
        action = Action.new(context, &block)
        pre_task.enhance(action)
      end

      task = manager[name]
      task.prepend(pre_task)
      pre_task
    end

    def build_post_task(name, post_name, context, &block)
      post_task = manager[post_name]
      if post_task.nil?
        post_task = Task.new(manager, post_name)
        manager.register(post_task)
      end

      if block_given?
        action = Action.new(context, &block)
        post_task.enhance(action)
      end

      task = manager[name]
      task.append(post_task)
      post_task
    end
  end
end
