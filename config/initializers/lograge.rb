# config/initializers/lograge.rb
Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.ignore_actions = ["ActiveStorage::DiskController#show",
                                   "ActiveStorage::RepresentationsController#show"]
end
