class Item < ActiveRecord::Base
  belongs_to :category
  has_many   :photos

  validates :name, presence: true
  validates :description, presence: true
  validates :category, presence: true

  def featured_photo
    featured_photo_id && photos.find(featured_photo_id)
  end
end
