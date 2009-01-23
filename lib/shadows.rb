module Shadows

  def self.shadow_class(base)
    "#{ base.name }Shadow".constantize
  rescue NameError
    Class.new Shadows::Base do
      helper = "#{ base.name.pluralize }Helper".constantize rescue nil
      include helper if helper
    end
  end

  @controllers = {}
  def self.free_controller
    @controllers.delete Thread.current
  end
  def self.controller
    @controllers[ Thread.current ]
  end
  def self.controller=(ctrl)
    @controllers[ Thread.current ] = ctrl
  end

  module Extension
    def attach_shadows(opts = {})
      extend Shadows::ClassMethods
      shadow.options = { :local_assigns => :attributes }.update opts
      include Shadows::InstanceMethods
    end
  end
  class Filter
    def self.filter(controller)
      Shadows.controller = controller
      yield
    ensure
      Shadows.free_controller
    end
  end

  module ClassMethods

    def self.extended(base)
      base.instance_variable_set :@shadow, Shadows.shadow_class(base)
    end
    attr_reader :shadow

  end
  module InstanceMethods

    def self.included(base)
      base.class_eval do
        alias_method :to_string_without_shadow, :to_s
        alias_method :to_s, :to_string_with_shadow
      end
    end


    def to_string_with_shadow(shape = nil, *args)
      shadow = shadows[ Shadows.controller ]
      shadow.to_s(shape, *args)
    end

    def shadows
      @shadows ||= begin
        shadow = self.class.shadow
        Hash.new { |h, base| h[base] = shadow.new self, base }
      end
    end

    def render(shape = nil, *args)
      shadow = shadows[ Shadows.controller ]

      Shadows.controller.
      instance_eval { render shadow.to_s(shape), *args }
    rescue
      to_string_with_shadow shape, *args
    end

  end

end
