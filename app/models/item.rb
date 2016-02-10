class Item < ActiveRecord::Base
  belongs_to :category
  has_many   :photos

  before_save :set_featured_photo

  validates :name, presence: true
  validates :category, presence: true

  store_accessor :properties

  def featured_photo
    featured_photo_id && photos.find(featured_photo_id)
  end

  private

  def set_featured_photo
    if self.featured_photo_id.nil? && self.photos.count > 0
      self.featured_photo_id = self.photos.first.id
    else
      true
    end
  end
end
