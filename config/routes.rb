Rails.application.routes.draw do
  resources :items, only: [:new, :edit, :show]
  get 'items/search'

  resources :cat_groups do
    get 'categories', to: 'categories#index'
  end
  resources :categories, except: [:index]

  scope :catalog do
    get '/', to: 'catalog#index'
  end

  root to: 'about#landing'
end
