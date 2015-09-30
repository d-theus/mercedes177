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
    respond_with Category
    .joins('LEFT JOIN items on items.category_id = categories.id GROUP BY categories.id')
    .select('categories.*, COUNT(items.id) AS item_count')
    .order('name ASC')
  end

  def destroy
    respond_with Category.destroy(params[:id])
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
