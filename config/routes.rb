Rails.application.routes.draw do
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
