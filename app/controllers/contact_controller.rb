class ContactController < ApplicationController
  def new
    @contact = ContactMessage.new
  end

  def create
    @contact = ContactMessage.new(contact_params)
    if @contact.valid?
      notification = Contact.contact_notification(@contact)
      notification.deliver
      redirect_to root_path
    else
      flash.now[:alert] = 'Ошибка при создании сообщения'
      render :new
    end
  end

  private

  def contact_params
    params.require(:contact_message).permit(:name, :email, :phone, :text)
  end
end
