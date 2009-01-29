module Shadows
  class Base < ActionView::Base

    def self.load_paths=(load_paths)
      Rails::Initializer.
      run :set_load_path, Rails.configuration do |config|
        config.load_paths += load_paths
      end
      Rails::Initializer.
      run :set_autoload_paths, Rails.configuration
      
      @@load_paths = load_paths
    end
    def self.load_paths
      @@load_paths
    end

    @@options = {}
    cattr_accessor :options

    def initialize(object, base)
      @origin = object
      super _load_paths, _assigns, base
    end

    def to_s(shape = nil, *args)
      _evaluate_assigns_and_ivars

      if shape.nil?
        render_shape :self, *args rescue @origin.to_string_without_shadow
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
    def _name
      @__name ||= @origin.class.name.underscore
    end
    def _load_paths
      name = _name and @@load_paths.map { |p| File.join p, name }
    end
    def _assigns
      case assigns = @@options[:assigns]
      when Symbol; @origin.send(assigns).to_hash
      when Hash; assigns
      else {}
      end.merge _name => @origin
    end

  end
end
