namespace :import do
  task blogs: :environment do
    include ActionView::Helpers::TextHelper

    all_content = JSON.parse(Rails.root.join("db/import/posts.json").read)
    blog_posts = all_content.select { |c| c["type"] = "blog" }
    blog_posts.each do |post|
      b = Blog.new(
        title: post["title"],
        body: simple_format(post["body_value"]),
        imported_id: post["nid"],
        created_at: Time.zone.at(post["created"].to_i)
      )
      b.save!
    end
  end

  task images: :environment do
    json = Rails.root.join("db/import/files.json").read
    images = JSON.parse(json)

    images.each do |image|
      filename = image["filename"]
      b = Blog.find_by(imported_id: image["entity_id"])
      Rails.root.join("db", "import", "files", filename).open do |file|
        ActiveRecord::Base.transaction do
          a = b.attachments.build(
            title: b.title,
            taken_at: b.created_at
          )
          a.image.attach(io: file, filename: filename, content_type: "image/jpeg")
          a.save
          puts "Uploaded #{filename} to #{image["entity_id"]}..."
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
