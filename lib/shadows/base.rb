module Shadows
  class Base < ActionView::Base

    def self.view_paths=(value)
      @view_paths = process_view_paths(value) if value
    end
    self.view_paths = []

    def self.view_paths
      if defined? @view_paths
        @view_paths
      else
        superclass.view_paths
      end
    end

    def self.append_view_path(path)
      @view_paths = superclass.view_paths.dup if !defined?(@view_paths) || @view_paths.nil?
      @view_paths.unshift(*path)
    end

    def self.inherited(base)
      base.instance_variable_set :@assigns, @assigns.dup if @assigns
    end
    def self.assigns=(assigns) @assigns = assigns end
    def self.assigns; @assigns end

    def initialize(object, base)
      @origin = object
      super self.class.view_paths, _assigns, base
    end

    def to_s(shape = nil, *args)
      _evaluate_assigns_and_ivars

      if shape.nil?
        render_self(*args)
      elsif respond_to? :"#{ shape }"
        send :"#{ shape }", *args
      else
        render_shape shape, *args
      end
    end

    protected
    def render_shape(shape, *args)
      opts = args.extract_options!
#      raise [ self.class.name, shape, opts ].inspect
      render opts.merge(:file => shape.to_s)
    end
    def render_self(*args)
      render_shape :self, *args
    rescue ActionView::MissingTemplate
      @origin.to_string_without_shadow
    end
    def _name
      @__name ||= @origin.class.name.underscore
    end
    def _basename
      @__basename ||= @origin.class.name.demodulize.underscore
    end
    def _assigns
      case assigns = self.class.assigns
      when Array
        assigns.inject({}) { |mem, key| mem.update key => @origin.send(key) }
      when Symbol
        value = @origin.send assigns
        if value.is_a? Hash then value
        else { assigns => value }
        end
      when Hash; assigns
      else {}
      end.merge _basename => @origin
    end

  end
end
