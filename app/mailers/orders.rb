class Orders < ActionMailer::Base
  default from: "orders@mercedes177.ru"

  def created_notification(order)
    @order = order
    mail(to: @order.email, subject: 'Новый заказ на mercedes177.ru')
  end
end
