# Shadows

Shadows is a simple implementation of the Presenter pattern.

## SYNOPSIS

`app/models/product.rb`

    class Product < ActiveRecord::Base
      attach_shadows
    end


`app/shadows/product/shadow.rb`

    class Product::Shadow < Shadows::Base

      def new
        form_for @product do |form|
          render :partial => 'form', :object => form
          submit_tag 'Create'
        end
      end

    end


`app/shadows/product/product.html.erb`

    

`app/controllers/products_controller.rb`

    class ProductsController < ApplicationController
      def show
        render :text => Product.find( params[:id] ).to_s(:self, self)
      end
      def new
        render :text => Product.new.to_s(:new, self)
      end
    end

## SETUP

## ROADMAP

1.0:

- implemented Presenter pattern
- TODO: write Shadow generators
- TODO: write Test suite
- TODO: write Documentation

Copyright (c) 2009 Florian Aßmann, released under the MIT license
