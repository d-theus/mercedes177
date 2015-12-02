Rails.application.routes.draw do
  devise_for :admins

  get 'orders/received'
  resources :orders

  get 'contact', controller: 'contact', action: 'new'
  post 'contact', controller: 'contact', action: 'create'

  get 'items/search', defaults: { format: :json}
  resources :items, defaults: { format: :json} do
    resources :photos, only: [:index, :create, :destroy]
  end
  scope 'templates' do
    get ':ctrl/:name', controller: :templates, action: :show
  end

  scope 'templates' do
    get ':ctrl/:name', controller: :templates, action: :show
  end

  resources :categories, defaults: { format: :json}

  scope :catalog do
    get '/', to: 'catalog#index'
    get 'static', to: 'catalog#static'
  end

  root to: 'about#landing'
  get 'about/info'
  get 'about/contacts'
  get 'about/policy'
  get 'about/offer'
end
