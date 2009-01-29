# Shadows

Shadows is a simple ActionView based implementation of the Presenter pattern.

## SYNOPSIS

app/models/product.rb

    class Product < ActiveRecord::Base
      attach_shadows :assigns => :attributes
    end


app/shadows/product/self.html.erb

    <%= @name %>


app/shadows/product_shadow.rb

    class Product::Shadow < Shadows::Base

      def form
        @product.new_record?? render_shape(:new) : render_shape(:edit)
      end

    end


app/controllers/products_controller.rb

    class ProductsController < ApplicationController

      def show
        product = Product.find params[:id]
        render :text => product.to_s, :layout => true
      end
      def new
        product = Product.new
        # :render not yet implemented
        product.render :form
      end

      # ...

    end

## SETUP

    $ script/plugin install git://github.com/boof/shadows.git

    # or
    $ git submodule add git://github.com/boof/shadows.git vendor/plugins/shadows

## ROADMAP

1st Version of Shadows:

- should implement Presenter pattern (almost complete)
- should have a Test suite (almost complete)
- should have generators (zero)
- should have documentation (only this file, yet)

Copyright (c) 2009 Florian Aßmann, released under the MIT license
