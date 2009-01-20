require 'shadows'
require 'shadows/base'

default_load_path = File.join Rails.root, %w[ app shadows ]
Shadows::Base.load_paths = [ default_load_path ]