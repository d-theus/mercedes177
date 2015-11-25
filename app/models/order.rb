class Order < ActiveRecord::Base
  validates_presence_of :first_name, :last_name, :phone, :email, :delivery_method
  validates :middle_name, presence: true, if: :post?
  validates :delivery_method, with: :valid_delivery_method?
  validates :status, with: :valid_status?
  validates :address, presence: true, unless: :pickup? 
  validates :email, format: /\A(\S+)@(.+)\.(\S+)\z/
  validates :phone, format: /\d{11}/
  validate  :has_positions?
  has_many :positions, dependent: :destroy

  DELIVERY_METHODS = ['Самовывоз', 'Трансп. Компания', 'Почта']
  STATUSES = %w(Новый Собирается Готов Отправлен Закрыт Отменен)

  def pickup?
    self.delivery_method == 'Самовывоз'
  end

  def post?
    self.delivery_method == 'Почта'
  end

  def has_positions?
    errors.add(:positions, "Нет позиций!") unless positions.size > 0
  end

  private

  def valid_delivery_method?(meth)
    DELIVERY_METHODS.include? meth
  end

  def valid_status?(stat)
    STATUSES.include? stat
  end
end
