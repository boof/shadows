require 'test_helper'

Item = Struct.new(:attributes) do
  extend Shadows::Extension
  attach_shadows

  def inspect
    'inspect'
  end

end

class ItemShadow < Shadows::Base

  def item_shadow
    'ItemShadow'
  end

end
module ItemsHelper

  def br
    tag :br
  end

  def items_helper
    'ItemsHelper'
  end
  def et
    drop :existing_template
  end

end

Expectations do

  expect 'inspect' do
    Item.new({}).to_s
  end
  expect 'ItemShadow' do
    Item.new({}).to_s :item_shadow
  end
  expect 'ItemsHelper' do
    Item.new({}).to_s :items_helper
  end
  expect 'Existing Template' do
    Item.new({}).to_s :existing_template
  end
  expect 'Existing Template' do
    Item.new({}).to_s :et
  end
  expect ActionView::MissingTemplate do
    Item.new({}).to_s :missing_template
  end
  expect 'attributes assigned locally' do
    # FIXME: assign attributes locally
    Item.new('var' => 'attributes assigned locally').to_s :var
  end
  expect '<br />' do
    Item.new({}).to_s :br
  end

end
