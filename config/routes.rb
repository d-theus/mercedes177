Rails.application.routes.draw do
  resources :items, only: [:new, :edit, :show]
  get 'items/search'

  resources :categories

  scope :catalog do
    get '/', to: 'catalog#index'
  end

  root to: 'about#landing'
end
