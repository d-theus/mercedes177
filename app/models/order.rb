class Order < ActiveRecord::Base
  validates_presence_of :first_name, :middle_name, :last_name, :phone, :email, :address
  has_many :positions
end
