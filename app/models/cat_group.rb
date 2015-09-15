class CatGroup < ActiveRecord::Base
  validates :name,
    presence: true,
    uniqueness: true,
    length: { within: 2..40 }
  has_many :categories
end
