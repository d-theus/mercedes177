class Order < ActiveRecord::Base
  validates_presence_of :first_name, :middle_name, :last_name, :phone, :email, :delivery_method
  validates :delivery_method, with: :valid_delivery_method?
  validates :address, presence: true, unless: :pickup? 
  validates :email, format: /\A(\S+)@(.+)\.(\S+)\z/
  validates :phone, format: /\d{11}/
  validate  :has_positions?
  has_many :positions

  DELIVERY_METHODS = %w(pickup courier post)

  def pickup?
    self.delivery_method == 'pickup'
  end

  def has_positions?
    errors.add(:positions, "Нет позиций!") unless positions.size > 0
  end

  private

  def valid_delivery_method?(meth)
    DELIVERY_METHODS.include? meth
  end
end
