namespace :import do
  task blogs: :environment do
    include ActionView::Helpers::TextHelper

    all_content = JSON.parse(File.read(Rails.root.join('db', 'import', 'posts.json')))
    blog_posts = all_content.select { |c| c["type"] = "blog" }
    blog_posts.each do |post|
      b = Blog.new(
        title: post["title"],
        body: simple_format(post["body_value"]),
        imported_id: post["nid"],
        created_at: Time.at(post["created"].to_i)
      )
      b.save!
    end
  end

  task images: :environment do
    json = File.read(Rails.root.join('db', 'import', 'files.json'))
    images = JSON.parse(json)

    images.each do |image|
      filename = image["filename"]
      b = Blog.find_by(imported_id: image['entity_id'])
      File.open(Rails.root.join('db', 'import', 'files', filename)) do |file|
        ActiveRecord::Base.transaction do
          b.images.attach(io: file, filename: filename, content_type: "image/jpeg")
          puts "Uploaded #{filename} to #{image['entity_id']}..."
        end
      end
    end
  end

  task purge_blogs: :environment do
    Blog.delete_all
  end

  task purge_images: :environment do
    Blog.find_each { |b| b.images.purge }
  end
end
