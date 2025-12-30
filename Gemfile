source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.4.8"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 8.1.0"
# Use sqlite3 as the database for Active Record
# gem 'sqlite3', '~> 1.4'
gem "pg"
# Use Puma as the app server
gem "puma", ">= 5.0"
# Use SCSS for stylesheets
gem "sassc-rails"
# Modern Rails asset pipeline
gem "importmap-rails"
gem "stimulus-rails"
gem "turbo-rails"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use Active Storage variant
gem "image_processing", "~> 1.2"
gem "mini_magick"
# Markdown processing
gem "redcarpet"
# Pagination
gem "kaminari"
# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false
# Less mad logs
gem "lograge"
# Nicer URLS
gem "friendly_id"
# Deployment
gem "kamal"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "bundler-audit"
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "database_consistency", require: false
  gem "dotenv-rails"
  # Linting
  gem "rubocop", require: false
  gem "rubocop-minitest", require: false
  gem "rubocop-rails", require: false
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "claude-on-rails"
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "listen"
  gem "web-console"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver", ">= 4.11"
  # Pin minitest for Rails 8 compatibility
  gem "minitest", "~> 5.25"
  # Accessibility testing with axe-core
  gem "axe-core-capybara"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
# OAuth authentication
gem "omniauth"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection"
