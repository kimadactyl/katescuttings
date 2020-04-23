class BlogsController < ApplicationController
  def index
    @blogs = Blog.teasers_sorted_by_month
    @almanac = Blog.almanac
  end

  def show
    @blog = Blog.find(params[:id])
  end
end
