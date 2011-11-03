require "#{ File.dirname __FILE__ }/core_init"

default_path = File.join Rails.root, %w[ app shadows ]
Shadows::Base.view_paths = [ default_path ]
ActiveSupport::Dependencies.autoload_paths += [ default_path ]
