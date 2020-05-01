class Admin::BlogsController < ApplicationController
  def index
    @blogs = Blog.all.limit(20)
  end

  def show
    @blog = Blog.find(params[:id])
  end
end
