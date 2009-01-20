module Shadows

  def self.shadow_class(base)
    "#{ base.name }Shadow".constantize
  rescue NameError
    Class.new Shadows::Base do
      helper = "#{ base.name.pluralize }Helper".constantize rescue nil
      include helper if helper
    end
  end

  module Extension
    def attach_shadows(opts = {})
      extend Shadows::ClassMethods
      shadow.options = { :local_assigns => :attributes }.update opts
      include Shadows::InstanceMethods
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
        alias_method_chain :initialize, :shadows
        alias_method_chain :to_s, :shadows
      end
    end

    def initialize_with_shadows(*args, &block)
      shadow    = self.class.shadow
      @shadows  = Hash.new { |h, base| h[base] = shadow.new self, base }

      initialize_without_shadows(*args, &block)
    end
    attr_reader :shadows

    def to_s_with_shadows(shape = nil, base = nil, *args)
      shadows[base].to_s(shape, *args)
    end

  end

end
