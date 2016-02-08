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
    @items = if params[:category_id]
               Item.where(category_id: params[:category_id]) .order('name ASC')
             else
               Item.order('name ASC')
             end
             .map do |item| 
               {
                 id:   item.id,
                 name: item.name,
                 serial: item.serial,
                 featured_photo: item.featured_photo.try(:image).try(:url)
               }
             end
    respond_with @items
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
    params.require(:item).permit(:name, :serial, :price, :count, :description, :notice, :category, :category_id, :body, :year, :featured_photo_id)
  end
end
