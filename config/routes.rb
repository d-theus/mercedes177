Rails.application.routes.draw do
  devise_for :admins

  get 'orders/received'
  resources :orders

  resources :items, defaults: { format: :json} do
    resources :photos, only: [:index, :create]
  end
  scope 'templates' do
    get ':ctrl/:name', controller: :templates, action: :show
  end
  get 'items/search', defaults: { format: :json}
  delete 'photos/:id', defaults: { format: :json }, controller: :photos, action: :destroy

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
end
