namespace :images do
  task import: :environment do
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

  task purge: :environment do
    Blog.find_each { |b| b.images.purge }
  end
end
