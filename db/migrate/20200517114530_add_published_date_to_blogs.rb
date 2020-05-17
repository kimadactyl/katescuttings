class AddPublishedDateToBlogs < ActiveRecord::Migration[6.0]
  def change
    add_column :blogs, :published_at, :datetime
    Blog.find_each { |blog| blog.update(published_at: blog.created_at) }
  end
end
