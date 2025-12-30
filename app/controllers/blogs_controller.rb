class BlogsController < ApplicationController
  def index
    if params["year"] && params["month"]
      @display = "month"
      @blogs = Blog.in_month(params[:year], params[:month])
                   .includes(:attachments, :rich_text_body)
      redirect_to blog_path(@blogs.first.friendly_id) if @blogs.one?
    else
      @display = "all"
      @blogs = Blog.teasers
                   .includes(:attachments, :rich_text_body)
                   .page(params[:page]).per(10)
    end
    @grouped_blogs = group_teasers_by_month(@blogs)
    @almanac = Rails.cache.fetch("blog_almanac", expires_in: 1.hour) { Blog.almanac }

    respond_to do |format|
      format.html
      format.rss { @blogs = Blog.teasers.includes(:rich_text_body).limit(20) }
    end
  end

  def show
    @blog = Blog.friendly.includes(:attachments, :rich_text_body).find(params[:id])
    @almanac = Rails.cache.fetch("blog_almanac", expires_in: 1.hour) { Blog.almanac }
  end

  def group_teasers_by_month(blogs)
    blogs.group_by { |b| b.published_at.strftime "%B %Y" }
  end
end
