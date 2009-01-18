require 'rubygems'
require 'expectations'
require 'action_view'

require "#{ File.dirname __FILE__ }/../init.rb"

module Rails
  def self.root
    "#{ File.dirname __FILE__ }"
  end
end

class << Shadows::Base
  def root
    "#{ File.dirname __FILE__ }/shadows"
  end
end

