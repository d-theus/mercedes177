class Orders < ActionMailer::Base
  default from: "orders@mercedes77.ru"

  def created_notification(order)
    @order = order
    mail(to: @order.email, subject: 'Новый заказ на mercedes77.ru')
  end
end
