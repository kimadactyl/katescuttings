class BlogsController < ApplicationController
  def index
    @blogs = Blog.order(created_at: :desc).limit(10)
  end

  def show
    @blog = Blog.find(params[:id])
  end
end
