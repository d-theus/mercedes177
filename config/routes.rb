Rails.application.routes.draw do
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
  end

  root to: 'about#landing'
end
