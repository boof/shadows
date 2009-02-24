module Shadows
  class Base < ActionView::Base

    class PathGateway < Array
      def <<(path) target << path; super end
      def replace(paths)
        each { |p| target.delete p }; super; each { |p| target.push p }
      end
      protected
      def target; @target ||= ActiveSupport::Dependencies.load_paths end
    end

    @@load_paths = PathGateway.new
    def self.load_paths=(paths) @@load_paths.replace paths end
    cattr_reader :load_paths

    def self.inherited(base)
      base.instance_variable_set :@assigns, @assigns.dup if @assigns
    end
    def self.assigns=(assigns) @assigns = assigns end
    def self.assigns; @assigns end

    def initialize(object, base)
      @origin = object
      super _load_paths, _assigns, base
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
    def _load_paths
      name = _name and @@load_paths.map { |p| File.join p, name }
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
