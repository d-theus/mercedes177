Rails.application.routes.draw do
  resources :cat_groups

  root to: 'about#landing'
end
