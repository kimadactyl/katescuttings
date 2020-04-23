class AddImagesToBlogs < ActiveRecord::Migration[6.0]
  def up
    Blog.find_each { |b| b.images.purge }
    images = JSON.parse(File.read(Rails.root.join('db', 'import', 'files.json')))

    images.each do |image|
      filename = image["filename"]
      b = Blog.find_by(imported_id: image['entity_id'])
      File.open(Rails.root.join('db', 'import', 'files', filename)) do |file|
        puts "Uploading #{filename}..."
        b.images.attach(
          io: file,
          filename: filename,
          content_type: 'image/jpeg'
        )
      end
    end
  end

  def down
    Blog.find_each { |b| b.images.purge }
  end
end
