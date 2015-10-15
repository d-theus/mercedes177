class Position < ActiveRecord::Base
  belongs_to :item
  belongs_to :order
  validate :enough_items?, on: :create
  before_create :update_item

  private

  def enough_items?
    if self.item.count >= self.count
      true
    else
      self.errors[:count] = 'Стольких единиц товара на складе не осталось.'
      false
    end
  end

  def update_item
    item = self.item
    item.update(count: item.count - self.count)
  end
end
