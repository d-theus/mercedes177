class CatalogController < ApplicationController
  def index
    @cat_groups = CatGroup.order('name ASC')
  end
end
