class ContactMessage
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming
  extend  ActiveModel::Translation

  attr_accessor :name, :text, :email, :phone

  validates_presence_of :name
  validates_presence_of :text
  validate :phone_or_email
  

  def persisted?
    false
  end

  private

  def phone_or_email
    if phone.blank? && email.blank?
      errors.add(:phone, 'Необходимо указать телефон или электронную почту')
      errors.add(:email, 'Необходимо указать телефон или электронную почту')
    end
  end
end
