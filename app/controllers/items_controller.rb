class ItemsController < ApplicationController
  before_filter :authenticate_admin!, except: [:show, :index]

  respond_to :json

  def create
    respond_to do |f|
      f.json { respond_with Item.create(item_params)}
      f.html do
        @item = Item.new(item_params)
        if @item.save
          redirect_to "/catalog#?item=#{@item.id}"
        else
          flash.now[:alert] = 'Ошибка при создании товара'
          render :new
        end
      end
    end
  end

  def show
    respond_with Item.find(params[:id])
  end

  def update
    respond_with Item.update(params[:id], item_params)
  end

  def destroy
    respond_with Item.destroy(params[:id])
  end

  def index
    respond_with Item.order('name ASC')
  end

  def new
    @item = Item.new(category_id: params[:category_id])
    @bodies = Item.select('body').uniq.map(&:body).to_json
    respond_to do |f|
      f.html
    end
  end

  private
  
  def item_params
    params.require(:item).permit(:name, :serial, :price, :count, :description, :notice, :category, :category_id, :body, :year)
  end
end
