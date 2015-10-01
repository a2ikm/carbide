require "carbide/version"
require "carbide/action"
require "carbide/manager"
require "carbide/task"
require "carbide/builder"

module Carbide
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    DEFAULT_OPTIONS = {
      manager:  :carbide_manager,
      prefix:   nil,
    }.freeze

    RUBY_RESERVED_WORDS = %w(
      alias and BEGIN begin break case class def defined? do else elsif END end
      ensure false for if in module next nil not or redo rescue retry return
      self super then true undef unless until when while yield
    ).freeze

    def carbide(options = nil)
      options = DEFAULT_OPTIONS.merge(options || {})

      manager = options[:manager]
      manager = "self.#{manager}" if RUBY_RESERVED_WORDS.include?(manager)

      prefix = options[:prefix]
      prefix = "#{prefix}_" if prefix && !prefix.to_s.end_with?("_")

      class_eval <<-RUBY, __FILE__, __LINE__+1
        def #{prefix}invoke(name, *args)
          task = #{manager}[name]
          if task
            task.invoke(*args)
          end
        end
        def #{prefix}task(name, &block)
          Carbide::Builder.new(#{manager}).build_task(name, self, &block)
        end
        def #{prefix}before(name, pre_name, &block)
          Carbide::Builder.new(#{manager}).build_pre_task(name, pre_name, self, &block)
        end
        def #{prefix}after(name, post_name, &block)
          Carbide::Builder.new(#{manager}).build_post_task(name, post_name, self, &block)
        end
      RUBY
    end
  end
end
