require "net/http"
require "json"
require "base64"

namespace :alt_text do
  ALT_TEXT_FILE = Rails.root.join("db/import/alt-text.json")
  BATCH_SIZE = 10
  CLAUDE_API_URL = URI("https://api.anthropic.com/v1/messages")
  SITE_URL = "https://katescuttings.net".freeze

  desc "Generate alt text for images using Claude's Vision API"
  task generate: :environment do
    unless ENV["ANTHROPIC_API_KEY"]
      puts "Error: ANTHROPIC_API_KEY environment variable not set"
      exit 1
    end

    alt_texts = load_alt_texts
    attachment_ids = Attachment.order(:id).pluck(:id)

    pending_ids = attachment_ids.reject { |id| alt_texts.key?(id.to_s) }

    puts "Total attachments: #{attachment_ids.count}"
    puts "Already processed: #{alt_texts.count}"
    puts "Pending: #{pending_ids.count}"
    puts

    if pending_ids.empty?
      puts "All attachments have alt text!"
      exit 0
    end

    batch = pending_ids.first(BATCH_SIZE)
    puts "Processing batch of #{batch.count}: IDs #{batch.first}-#{batch.last}"
    puts

    batch.each do |id|
      attachment = Attachment.find(id)
      puts "Processing attachment #{id} (#{attachment.title})..."

      begin
        image_url = get_image_url(attachment)
        alt_text = generate_alt_text_for_url(image_url)

        if alt_text
          alt_texts[id.to_s] = alt_text
          save_alt_texts(alt_texts)
          puts "  -> #{alt_text}"
        else
          puts "  -> Failed to generate alt text"
        end
      rescue StandardError => e
        puts "  -> Error: #{e.message}"
      end

      puts
    end

    puts "Batch complete. Progress: #{alt_texts.count}/#{attachment_ids.count}"
  end

  desc "Show alt text generation progress"
  task progress: :environment do
    alt_texts = load_alt_texts
    total = Attachment.count

    puts "Alt text progress: #{alt_texts.count}/#{total} (#{(alt_texts.count * 100.0 / total).round(1)}%)"
    puts "Remaining: #{total - alt_texts.count}"
  end

  desc "Apply alt text from JSON to database (also sets title if blank)"
  task apply: :environment do
    alt_texts = load_alt_texts
    updated_alt = 0
    updated_title = 0

    alt_texts.each do |id, text|
      attachment = Attachment.find_by(id: id)
      next unless attachment

      changes = {}
      if attachment.alt_text.blank?
        changes[:alt_text] = text
        updated_alt += 1
      end
      if attachment.title.blank?
        changes[:title] = text
        updated_title += 1
      end

      if changes.any?
        attachment.update!(changes)
        puts "Updated attachment #{id}: #{changes.keys.join(", ")}"
      end
    end

    puts "Updated #{updated_alt} alt_text fields, #{updated_title} title fields"
  end

  private

  def load_alt_texts
    return {} unless File.exist?(ALT_TEXT_FILE)

    JSON.parse(File.read(ALT_TEXT_FILE))
  end

  def save_alt_texts(alt_texts)
    File.write(ALT_TEXT_FILE, JSON.pretty_generate(alt_texts))
  end

  def get_image_url(attachment)
    # Get the blob URL for the original image
    blob = attachment.image.blob
    "#{SITE_URL}/rails/active_storage/blobs/redirect/#{blob.signed_id}/#{blob.filename}"
  end

  def generate_alt_text_for_url(image_url)
    # Fetch image and convert to base64
    image_uri = URI(image_url)
    http = Net::HTTP.new(image_uri.host, image_uri.port)
    http.use_ssl = true
    response = http.get(image_uri.request_uri)

    raise "Failed to fetch image: #{response.code}" if response.code != "200"

    image_data = Base64.strict_encode64(response.body)
    media_type = response["content-type"] || "image/jpeg"

    # Call Claude API
    http = Net::HTTP.new(CLAUDE_API_URL.host, CLAUDE_API_URL.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(CLAUDE_API_URL)
    request["Content-Type"] = "application/json"
    request["x-api-key"] = ENV.fetch("ANTHROPIC_API_KEY", nil)
    request["anthropic-version"] = "2023-06-01"

    request.body = {
      model: "claude-sonnet-4-20250514",
      max_tokens: 200,
      messages: [{
        role: "user",
        content: [
          {
            type: "image",
            source: {
              type: "base64",
              media_type: media_type,
              data: image_data
            }
          },
          {
            type: "text",
            text: "Write a concise alt text description for this garden photograph. Focus on the main subject (plants, flowers, garden features) and include botanical names where recognizable. Keep it under 150 characters. Output only the description, no quotes or prefix."
          }
        ]
      }]
    }.to_json

    response = http.request(request)

    raise "Claude API error: #{response.code} - #{response.body}" if response.code != "200"

    result = JSON.parse(response.body)
    result.dig("content", 0, "text")&.strip
  end
end
