# frozen_string_literal: true

class SessionsController < ApplicationController
  ALLOWED_DOMAINS = %w[thefoales.net gfsc.studio].freeze

  def new
    # Login page
  end

  def create
    auth = request.env["omniauth.auth"]
    email = auth.info.email
    domain = email.split("@").last

    unless ALLOWED_DOMAINS.include?(domain)
      flash[:error] = "Sorry, only family members can sign in."
      redirect_to(login_path) && return
    end

    user = User.find_or_create_by(provider: auth.provider, uid: auth.uid) do |u|
      u.email = email
      u.name = auth.info.name
      u.avatar_url = auth.info.image
    end

    # Update user info in case it changed
    user.update(
      email: email,
      name: auth.info.name,
      avatar_url: auth.info.image
    )

    session[:user_id] = user.id
    flash[:success] = "Welcome, #{user.name}!"
    redirect_to admin_root_path
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You have been signed out."
    redirect_to root_path
  end

  def failure
    flash[:error] = "Authentication failed. Please try again."
    redirect_to login_path
  end
end
