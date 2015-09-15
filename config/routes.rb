Rails.application.routes.draw do
  resources :cat_groups

  scope :catalog do
    get '/', to: 'catalog#index'
  end

  scope :catalog do
    get '/', to: 'catalog#index'
  end

  root to: 'about#landing'
end
