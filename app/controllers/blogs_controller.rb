class BlogsController < ApplicationController
  def index
    if params["year"] && params["month"]
      @display = 'month'
      @blogs = Blog.in_month(params[:year], params[:month])
      redirect_to blog_path(@blogs.first.id) if @blogs.count == 1
    else
      @display = 'all'
      @blogs = Blog.teasers.page(params[:page]).per(10)
    end
    @grouped_blogs = group_teasers_by_month(@blogs)
    @almanac = Blog.almanac
  end

  def show
    @blog = Blog.find(params[:id])
    @almanac = Blog.almanac
  end

  def group_teasers_by_month(blogs)
    blogs.group_by { |b| b.published_at.strftime '%B %Y' }
  end

end
