Rails.application.routes.draw do
  resources :cat_groups, param: :cg_id

  root to: 'about#landing'
end
