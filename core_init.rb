require "#{ File.dirname __FILE__ }/lib/shadows"
require "#{ File.dirname __FILE__ }/lib/shadows/base"
ActiveRecord::Base.extend Shadows::Extension rescue nil
ActionController::Base.around_filter Shadows::Filter rescue nil
