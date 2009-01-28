require 'rubygems'
require 'expectations'
require 'action_view'

module Rails
  class Initializer
    @commands = {}
    def self.run(command, config = false)
      @commands[command] = config
    end
  end
  @root = "#{ File.dirname __FILE__ }"
  class << self; attr_reader :root; end
  
  class Configuration
    attr_accessor :load_paths
  end
  @configuration = Configuration.new
  @configuration.load_paths = []
  class << self; attr_reader :configuration; end
end

class Controller
  def self.master_helper_module() Module.new end
end

require "#{ File.dirname __FILE__ }/../init.rb"
Shadows.controller = Controller.new
