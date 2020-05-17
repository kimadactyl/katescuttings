class UpdateBlogSlugs < ActiveRecord::Migration[6.0]
  def change
    Blog.find_each(&:save)
  end
end
