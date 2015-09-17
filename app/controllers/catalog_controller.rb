class CatalogController < ApplicationController
  def index
    @cgs = CatGroup.order('name ASC')
  end
end
