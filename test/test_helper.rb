require 'rubygems'
require 'expectations'
require 'action_view'

module Rails
  @root = "#{ File.dirname __FILE__ }"
  class << self; attr_reader :root; end
  
  class Configuration
    attr_accessor :load_paths
  end
  @configuration = Configuration.new
  @configuration.load_paths = []
  class << self; attr_reader :configuration; end
end

require "#{ File.dirname __FILE__ }/../init.rb"
