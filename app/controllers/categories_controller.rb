class CategoriesController < ApplicationController
  before_filter :admin?, except: [:index, :show]
  before_filter :fetch_group
  before_filter :fetch_category, only: [:edit, :update, :show, :destroy]

  def new
    @cat = CatGroup.build_category
    render :new, layout: false
  end

  def create
    @cat = Category.new(category_params)
    if @cat.save
      render :show, layout: false
    else
      render partial: 'categories/error', status: :unprocessable_entity, layout: false
    end
  end

  def edit
    render :edit, layout: false
  end

  def update
    if @cat.update(category_params)
      render nothing: true
    else
      render :edit, status: :unprocessable_entity, layout: false
    end
  end

  def show
  end

  def index
    @cats = CatGroup.find(params[:cg_id]).categories
  end

  def destroy
    if @cat.delete
      render nothing: true
    else
      render partial: 'categories/errors', status: :bad_request, layout: false
    end
  end

  private

  def fetch_category
    @cg.categories.find(params[:c_id])
  end

  def fetch_group
    @cg = CatGroup.find(params[:cg_id])
  end

  def category_params
    params.require(:cat_group).require(:category).permit(:name)
  end
end
