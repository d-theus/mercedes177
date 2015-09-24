class Photo < ActiveRecord::Base
  belongs_to :item

  mount_base64_uploader :image, PhotoUploader
end
