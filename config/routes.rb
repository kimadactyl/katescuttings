Rails.application.routes.draw do
  root 'blogs#index'
  resources :blogs

  get 'kate', to: 'pages#kate'
  get 'garden', to: 'pages#garden'
  get 'book', to: 'pages#book'
end
