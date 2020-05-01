class Admin::BlogsController < ApplicationController
  http_basic_authenticate_with name: ENV['USERNAME'], password: ENV['PASSWORD']

  def index
    @blogs = Blog.order(created_at: :desc).limit(20)
  end

  def edit
    @blog = Blog.find(params[:id])
  end
end
