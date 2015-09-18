class CatGroupsController < ApplicationController
  before_filter :admin?, except: [:show, :index]
  before_filter :fetch_group, only: [ :show, :edit, :update, :destroy ]

  def new
    @cg = CatGroup.new
    render :new, layout: false
  end

  def create
    @cg = CatGroup.new(cat_group_params)
    if @cg.save
      render :show, layout: false
    else
      render partial: 'cat_groups/error', status: :unprocessable_entity, layout: false
    end
  end

  def edit
    render :edit, layout: false
  end

  def update
    if @cg.update(cat_group_params)
      render nothing: true
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def index
    @cgs = CatGroup.all
    respond_to do |f|
      f.html
      f.json { render(json: { cat_groups: @cgs }) }
    end
  end

  def show
  end

  def destroy
    if @cg.delete
      render nothing: true
    else
      render partial: 'cat_groups/error', status: :bad_request
    end
  end

  private

  def cat_group_params
    params.require(:cat_group).permit(:name)
  rescue
    false
  end

  def fetch_group
    @cg = CatGroup.find(params[:id])
  end
end
