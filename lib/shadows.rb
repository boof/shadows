module Shadows

  module Extension
    def attach_shadows
      extend Shadows::ClassMethods
      include Shadows::InstanceMethods
    end
  end

  module ClassMethods

    def self.extended(base)
      class << base
        extend ActiveSupport::Memoizable
        memoize :shadow
      end
    end

    def shadow
      shadow = begin
        "#{ name }Shadow".constantize
      rescue
        Class.new Shadows::Base
      end

      helper = "#{ name.pluralize }Helper".constantize rescue nil
      shadow.class_eval { include helper } if helper

      shadow
    end

  end
  module InstanceMethods

    def to_s(shape = nil, base = nil, *args)
      shadows[base].to_s(shape, *args)
    end

    def shadows
      shadow = self.class.shadow
      @__shadows ||= Hash.new { |h, base| h[base] = shadow.new self, base }
    end

  end

end
