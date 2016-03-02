class PhotosController < ApplicationController
  before_filter :authenticate_admin!, except: [:show, :index]

  respond_to :json

  def create
    Item.find(params[:item_id]).photos.create!(image: params[:data])
    render nothing: true
  end

  def destroy
    @item = Item.find(params[:item_id])
    if @item.featured_photo_id == params[:id].to_i
      respond_with @item.delete_featured_photo
    else
      respond_with Photo.delete(params[:id])
    end
  end

  def index
    item = Item.includes(:photos).find(params[:item_id])
    respond_with(photos: item.photos.map(&:to_h), featured: item.featured_photo.try(:to_h) )
  end
end
