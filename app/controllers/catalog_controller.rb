class CatalogController < ApplicationController
  def index
  end

  def static
    @categories = Category.order('name')
    @items = Item.all
  end
end
