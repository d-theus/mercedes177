Rails.application.routes.draw do
  resources :items, only: [:new, :edit, :show]
  get 'items/search'

  scope 'templates' do
    get ':ctrl/:name', controller: :templates, action: :show
  end

  resources :categories

  scope :catalog do
    get '/', to: 'catalog#index'
  end

  root to: 'about#landing'
end
