Rails.application.routes.draw do
  resources :cat_groups do
    get 'categories', to: 'categories#index'
  end
  resources :categories, except: [:index]

  scope :catalog do
    get '/', to: 'catalog#index'
  end

  root to: 'about#landing'
end
