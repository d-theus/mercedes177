class Category < ActiveRecord::Base
  validates :name,
    presence: true,
    uniqueness: true,
    length: { within: 2..40 }
  has_and_belongs_to_many :cat_groups
end
