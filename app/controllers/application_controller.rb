class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def example
    render text: 'Example'
  end

  def require_admin
    admin = Rails.env.development? || ( current_user && current_user.admin? )
    #admin = false
    if admin
      true
    else
      flash[:error] = "Требуются права администратора"
      redirect_to root_path
    end
  end

  def unauthorized
      render(
        file: File.join(Rails.root, 'public/403.html'),
        status: 403,
        layout: false
      )
  end

  def admin?
    if Rails.env.development?
      return true
    else
      unauthorized
    end
  end

  def unauthorized
      render(
        file: File.join(Rails.root, 'public/403.html'),
        status: 403,
        layout: false
      )
  end
end
