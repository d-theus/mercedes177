class CatGroupsController < ApplicationController
  before_filter :admin?, except: [:show, :index]
  before_filter :fetch_group, only: [ :edit, :update, :destroy ]

  def new
    @cat_group = CatGroup.new
  end

  def create
    @cat_group = CatGroup.new(cat_group_params)
    if @cat_group.save
      render nothing: true
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @cat_group.update(cat_group_params)
      render nothing: true
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def index
    @cat_groups = CatGroup.all
    respond_to do |f|
      f.html
      f.json { render(json: { cat_groups: @cat_groups }) }
    end
  end

  def show
    @cat_group = CatGroup.find(params[:id])
  end

  def destroy
    if @cat_group.delete
      render nothing: true
    else
      render nothing: true,
        status: :bad_request
    end
  end

  private

  def cat_group_params
    params.require(:cat_group).permit(:name)
  rescue
    false
  end

  def fetch_group
    @cat_group = CatGroup.find(params[:id])
  end
end
