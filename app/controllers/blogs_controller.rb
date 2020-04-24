class BlogsController < ApplicationController
  def index
    @blogs = Blog.teasers.page(params[:page]).per(10)
    @grouped_blogs = group_teasers_by_month(@blogs)
    @almanac = Blog.almanac
  end

  def show
    @blog = Blog.find(params[:id])
  end

  def group_teasers_by_month(blogs)
    blogs.group_by { |b| b.created_at.strftime '%B %Y' }
  end
end
