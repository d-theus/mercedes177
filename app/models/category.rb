class Category < ActiveRecord::Base
  HUMANIZED_ATTRIBUTES = {
    cat_groups: 'Группы категорий'
  }
  validates :name,
    presence: true,
    uniqueness: true,
    length: { within: 2..40 }
  
  has_many :items

  def self.human_attribute_name(attr, option={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
end
