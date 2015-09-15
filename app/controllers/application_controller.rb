class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def example
    render text: 'Example'
  end

  def admin?
    render(
      file: File.join(Rails.root, 'public/403.html'),
      status: 403,
      layout: false
    )
  end
end
