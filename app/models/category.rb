class Category < ActiveRecord::Base
  HUMANIZED_ATTRIBUTES = {
    cat_groups: 'Группы категорий'
  }
  validates :name,
    presence: true,
    uniqueness: true,
    length: { within: 2..40 }
  
  validates :cat_groups,
    presence: { message: "должны содержать как минимум одну." }
  has_and_belongs_to_many :cat_groups
  has_many :items

  def self.human_attribute_name(attr, option={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
end
