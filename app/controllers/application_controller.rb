# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    # Auto-login in development
    if Rails.env.development? && !logged_in? && (user = User.first)
      session[:user_id] = user.id
      return
    end

    return if logged_in?

    flash[:error] = "Please sign in to access this area."
    redirect_to login_path
  end
end
