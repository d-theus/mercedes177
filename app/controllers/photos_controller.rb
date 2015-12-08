class PhotosController < ApplicationController
  before_filter :authenticate_admin!, except: [:show, :index]

  respond_to :json

  def create
    Item.find(params[:item_id]).photos.create(image: params[:data])
    render nothing: true
  end

  def destroy
    respond_with Photo.delete(params[:id])
  end

  def index
    respond_with Item.find(params[:item_id]).photos.map { |p| {full: p.image_url, preview: p.image_url(:preview), thumb: p.image_url(:thumb), id: p.id}}
  end
end
