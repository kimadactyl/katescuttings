Rails.application.routes.draw do
  # Health check for Kamal/load balancers
  get "up" => "rails/health#show", as: :rails_health_check

  # SEO
  get "sitemap.xml", to: "sitemaps#show", as: :sitemap, defaults: { format: "xml" }
  get "index.xml", to: "blogs#index", as: :rss_feed, defaults: { format: "rss" }

  root "blogs#index"
  resources :blogs, only: %i[show index]

  get "kate", to: "pages#kate"
  get "garden", to: "pages#garden"
  get "book", to: "pages#book"

  # Authentication
  get "login", to: "sessions#new", as: :login
  delete "logout", to: "sessions#destroy", as: :logout
  get "auth/:provider/callback", to: "sessions#create"
  get "auth/failure", to: "sessions#failure"

  namespace :admin do
    resources :blogs
    root "blogs#index"
  end
end
