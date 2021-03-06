class Photo < ActiveRecord::Base
  belongs_to :item

  mount_base64_uploader :image, PhotoUploader

  def to_h
    { big: image_url(:big), preview: image_url(:preview), thumb: image_url(:thumb), id: id}
  end
end
