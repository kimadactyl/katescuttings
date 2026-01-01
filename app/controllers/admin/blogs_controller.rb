module Admin
  class BlogsController < ApplicationController
    before_action :require_login
    before_action :set_blog, only: %i[edit update destroy]

    def index
      @blogs = Blog.includes(attachments: { image_attachment: :blob })

      # Search
      if params[:q].present?
        @blogs = @blogs.where("title ILIKE ?", "%#{params[:q]}%")
      end

      # Filter by status
      case params[:status]
      when "published"
        @blogs = @blogs.where("published_at <= ?", Time.current)
      when "scheduled"
        @blogs = @blogs.where("published_at > ?", Time.current)
      end

      # Sorting
      sort_column = %w[title created_at published_at].include?(params[:sort]) ? params[:sort] : "created_at"
      sort_direction = params[:direction] == "asc" ? :asc : :desc
      @blogs = @blogs.order(sort_column => sort_direction)

      @blogs = @blogs.page(params[:page]).per(25)
    end

    def new
      @blog = Blog.new
      @blog.published_at = Time.zone.now
    end

    def edit; end

    def create
      @blog = Blog.new(blog_params)

      if @blog.save
        flash[:success] = "Successfully created new blog"
        redirect_to admin_blogs_path
      else
        render "new"
      end
    end

    def update
      if @blog.update(blog_params)
        flash[:success] = "Post updated"
        redirect_to admin_blogs_path
      else
        render "edit"
      end
    end

    def destroy
      @blog.destroy
      redirect_to admin_blogs_path
    end

    private

    def blog_params
      params.expect(
        blog: [:title,
               :body,
               :published_at,
               attachments_attributes: [[:id, :title, :alt_text, :image, :_destroy]]]
      )
    end

    def set_blog
      @blog = Blog.friendly.find(params[:id])
    end
  end
end
