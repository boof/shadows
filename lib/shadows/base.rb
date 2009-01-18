module Shadows
  class Base < ActionView::Base

    def self.root
      # TODO: make this configurable
      File.join Rails.root, %w[ app shadows ]
    end

    def initialize(model, base)
      # TODO: Initialize base when controller instance is created
      name      = model.class.name.underscore
      load_path = File.join Shadows::Base.root, name
      super [ load_path ], { name => model, :model => model }, base
    end

    def to_s(shape = nil, *args)
      _evaluate_assigns_and_ivars

      if shape.nil?
        drop :self, *args rescue escape_once @assigns[:model].inspect
      elsif respond_to? :"#{ shape }"
        send :"#{ shape }", *args
      else
        drop shape, *args
      end
    end

    protected
    def drop(shape, *args)
      opts = args.extract_options!
      opts[:locals] ||= {}
      opts[:locals].update @assigns[:model].attributes

      render opts.merge(:file => shape.to_s)
    end

  end
end
