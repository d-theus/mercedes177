Rails.application.routes.draw do
  resources :items, defaults: { format: :json}
  get 'items/search', defaults: { format: :json}

  scope 'templates' do
    get ':ctrl/:name', controller: :templates, action: :show
  end

  resources :categories, defaults: { format: :json}

  scope :catalog do
    get '/', to: 'catalog#index'
  end

  root to: 'about#landing'
end
