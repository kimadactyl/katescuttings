# frozen_string_literal: true

class SitemapsController < ApplicationController
  def show
    @blogs = Blog.order(published_at: :desc)
    respond_to do |format|
      format.xml
    end
  end
end
