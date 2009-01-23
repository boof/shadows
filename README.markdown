# Shadows

Shadows is a simple implementation of the Presenter pattern.

## SYNOPSIS

`app/models/product.rb`

    class Product < ActiveRecord::Base
      attach_shadows
    end


`app/shadows/product/self.html.erb`

    I'm dropped when render/to_s is called without parameters.


`app/shadows/product/shadow.rb`

    class Product::Shadow < Shadows::Base

      # Is called when Shadow responds to render/to_s parameter.
      def form
        @product.new_record?? drop(:new) : drop(:edit)
      end

    end


`app/controllers/products_controller.rb`

    class ProductsController < ApplicationController
      def show
        product = Product.find params[:id]
        product.render
      end
      def new
        product = Product.new
        product.render :form
      end
    end

## SETUP

## ROADMAP

1st Version of Shadows:

- should implement Presenter pattern (ok)
- should have a Test suite (almost complete)
- should have generators (zero)
- should have documentation (only this file, yet)

Copyright (c) 2009 Florian Aßmann, released under the MIT license
