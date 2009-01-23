module Shadows
  class Base < ActionView::Base

    def self.load_paths=(paths)
      @@load_paths = paths
      Rails.configuration.load_paths |= paths
    end
    def self.load_paths
      @@load_paths
    end

    @@options = {}
    cattr_accessor :options

    def initialize(origin, base)
      name        = origin.class.name.underscore
      load_paths  = @@load_paths.map { |p| File.join p, name }

      super load_paths, { name => origin, :origin => origin }, base
    end

    def to_s(shape = nil, *args)
      _evaluate_assigns_and_ivars

      if shape.nil?
        drop :self, *args rescue @assigns[:origin].to_string_without_shadow
      elsif respond_to? :"#{ shape }"
        send :"#{ shape }", *args
      else
        drop shape, *args
      end
    end

    protected
    def drop(shape, *args)
      opts = args.extract_options!
      opts[:locals] = opts.delete(:locals) || {}

      case locals = @@options[:local_assigns]
      when Hash
        opts[:locals].update locals
      when Symbol
        opts[:locals].update @assigns[:origin].send(locals)
      end

      render opts.merge(:file => shape.to_s)
    end

  end
end
