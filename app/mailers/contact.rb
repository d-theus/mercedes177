class Contact < ActionMailer::Base
  default from: "contact@mercedes177.ru"

  def contact_notification(contact) 
    @contact = contact
    mail(to: ENV['ADMIN_EMAIL'].split(':'), subject: 'Сообщение на mercedes177.ru')
  end
end
