class Item < ActiveRecord::Base
  belongs_to :category
  has_many   :photos

  validates :name, presence: true
  validates :serial, presence: true
  validates :description, presence: true
  validates :category, presence: true
end
