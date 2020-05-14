class Admin::BlogsController < ApplicationController
  http_basic_authenticate_with name: ENV['USERNAME'], password: ENV['PASSWORD']
  before_action :set_blog, only: %i[edit update destroy]

  def index
    @blogs = Blog.order(created_at: :desc).page(params[:page]).per(25)
  end

  def new
    @blog = Blog.new
    3.times { @blog.attachments.build }
  end

  def create
    @blog = Blog.new(blog_params)

    if @blog.save
      flash[:success] = "Successfully created new blog"
      redirect_to edit_admin_blog_path(@blog)
    else
      render 'new'
    end
  end

  def edit
    1.times { @blog.attachments.build }
  end

  def update
    puts blog_params
    @blog.update(blog_params)
    redirect_to edit_admin_blog_path(@blog)
  end

  def destroy
    @blog.destroy
    redirect_to admin_blogs_path
  end

  private

  def blog_params
    params.require(:blog).permit(
      :title,
      :body,
      attachments_attributes: [:id, :title, :image, :_destroy]
    )
  end

  def set_blog
    @blog = Blog.find(params[:id])
  end
end
