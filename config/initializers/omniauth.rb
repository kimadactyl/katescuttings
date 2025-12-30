# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           ENV.fetch("GOOGLE_CLIENT_ID", nil),
           ENV.fetch("GOOGLE_CLIENT_SECRET", nil),
           {
             scope: "email,profile",
             prompt: "select_account",
             hd: %w[thefoales.net gfsc.studio] # Restrict to family domains
           }
end

OmniAuth.config.allowed_request_methods = [:post]

# Set the full host for callbacks in production
OmniAuth.config.full_host = Rails.env.production? ? "https://katescuttings.net" : nil
