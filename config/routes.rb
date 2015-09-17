Rails.application.routes.draw do
  resources :cat_groups do
    resources :categories
  end

  scope :catalog do
    get '/', to: 'catalog#index'
  end

  root to: 'about#landing'
end
