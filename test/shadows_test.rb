require 'test_helper'

$shadows_path = "#{ File.dirname __FILE__ }/shadows"

class WithShadowShadow < Shadows::Base

  def with_shadow; 'WithShadow'; end

end
WithShadow = Struct.new(:attributes)
WithShadow.extend Shadows::Extension
WithShadow.attach_shadows

module WithHelpersHelper

  def br; tag :br; end
  def with_helper; 'WithHelper'; end
  def et; drop :existing_template; end

end
WithHelper = Struct.new(:attributes)
WithHelper.extend Shadows::Extension
WithHelper.attach_shadows

Expectations do

  expect [ File.join(Rails.root, %w[ app shadows ]), $shadows_path ] do
    Shadows::Base.load_paths += [$shadows_path]
  end

  expect(/WithShadow/) do
    WithShadow.new({}).to_s
  end
  expect(/WithHelper/) do
    WithHelper.new({}).to_s
  end
  expect 'WithShadow' do
    WithShadow.new({}).to_s :with_shadow
  end
  expect 'WithHelper' do
    WithHelper.new({}).to_s :with_helper
  end
  expect 'Existing Template' do
    WithShadow.new({}).to_s :existing_template
  end
  expect 'Existing Template' do
    WithHelper.new({}).to_s :et
  end
  expect ActionView::MissingTemplate do
    WithShadow.new({}).to_s :missing_template
  end
  expect 'attributes assigned locally' do
    WithShadow.new(:var => 'attributes assigned locally').to_s :var
  end
  expect '<br />' do
    WithHelper.new({}).to_s :br
  end

end
