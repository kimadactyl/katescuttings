Rails.application.routes.draw do
  # Health check for Kamal/load balancers
  get "up" => "rails/health#show", as: :rails_health_check

  root 'blogs#index'
  resources :blogs, only: %i[show index]

  get 'kate', to: 'pages#kate'
  get 'garden', to: 'pages#garden'
  get 'book', to: 'pages#book'

  namespace :admin do
    resources :blogs
    root 'blogs#index'
  end
end
