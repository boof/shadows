module Shadows

  def self.shadow_class(base, fallback = nil)
    shadow_name = "#{ base.name }Shadow"
    shadow_name.constantize
  rescue NameError => e
    return fallback if fallback

    anon_shadow_class = Class.new Shadows::Base do
      helper = "#{ base.name.pluralize }Helper".constantize rescue nil
      include helper if helper
    end

    names = shadow_name.split '::'
    basename = names.pop

    # Crawl outer classes until we have our class we assign the shadow class
    # to.
    names.inject(Class) { |klass, name| klass.const_get name.to_sym }.
      const_set basename.to_sym, anon_shadow_class
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
      include Shadows::InstanceMethods

      shadow.assigns = opts[:assigns]
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
    def inherited(base)
      super
      base.instance_variable_set :@shadow, Shadows.shadow_class(base, @shadow)
    end

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
        Hash.new do |h, base|
          template = shadow.new self, base
          template.helpers.send :include, base.class.master_helper_module
          h[base] = template
        end
      end
    end

    def render(shape = nil, *args)
      shadow = shadows[ Shadows.controller ]

      Shadows.controller.instance_eval do
        render({ :text => shadow.to_s(shape) }, *args)
      end
    rescue
      to_string_with_shadow shape, *args
    end

  end

end
