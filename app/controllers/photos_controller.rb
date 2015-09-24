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

  private

  def photo_params
    params.require(:photo).permit(:image)
  end
end
