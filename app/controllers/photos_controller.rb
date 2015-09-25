class PhotosController < ApplicationController
  before_filter :admin?, except: [:index]

  respond_to :json

  def create
    Item.find(params[:item_id]).photos.create(photo_params)
    render nothing: true
  end

  def destoy
    respond_with Photo.delete(params[:id])
  end

  def index
    respond_with Item.find(params[:item_id]).photos.map { |p| {full: p.image_url, preview: p.image_url(:preview), thumb: p.image_url(:thumb)}}
  end

  private

  def photo_params
    params.require(:photo).permit(:image)
  end
end
