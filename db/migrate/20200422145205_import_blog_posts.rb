class ImportBlogPosts < ActiveRecord::Migration[6.0]
  def up
    all_content = JSON.parse(File.read(Rails.root.join('db', 'import', 'posts.json')))
    blog_posts = all_content.select { |c| c["type"] = "blog" }
    blog_posts.each do |post|
      b = Blog.new(
        title: post["title"],
        body: post["body_value"],
        imported_id: post["nid"],
        created_at: Time.at(post["created"].to_i)
      )
      b.save!
    end
  end

  def down
    Blog.delete_all
  end
end
