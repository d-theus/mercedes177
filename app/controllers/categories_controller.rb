class CategoriesController < ApplicationController
  before_filter :admin?, except: [:index, :show]

  respond_to :json

  def create
    respond_with Category.create(category_params)
  end

  def update
    respond_with Category.update(params[:id], category_params)
  end

  def show
    respond_with Category.find(params[:id])
  end

  def index
    respond_with Category.order('name ASC')
  end

  def destroy
    respond_with Category.destroy(params[:id])
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
