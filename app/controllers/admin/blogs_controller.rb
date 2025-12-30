module Admin
  class BlogsController < ApplicationController
    before_action :require_login
    before_action :set_blog, only: %i[edit update destroy]

    def index
      @blogs = Blog.order(created_at: :desc).page(params[:page]).per(25)
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
        redirect_to edit_admin_blog_path(@blog)
      else
        render "new"
      end
    end

    def update
      @blog.update(blog_params)
      redirect_to edit_admin_blog_path(@blog)
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
               { attachments_attributes: %i[id title alt_text image _destroy] }]
      )
    end

    def set_blog
      @blog = Blog.friendly.find(params[:id])
    end
  end
end
