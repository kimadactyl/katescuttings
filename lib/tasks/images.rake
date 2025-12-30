namespace :images do
  desc "Regenerate watermarked variants for all attachments"
  task regenerate_watermarks: :environment do
    # Delete existing watermarked variants so they get regenerated
    count = 0

    Attachment.includes(image_attachment: :blob).find_each do |attachment|
      next unless attachment.image.attached?

      # The watermarked variant key includes the watermark option
      # We need to delete any existing variants and let them regenerate
      blob = attachment.image.blob

      # Delete variant records for this blob (they'll regenerate on next request)
      if blob.variant_records.any?
        blob.variant_records.destroy_all
        count += 1
        puts "Cleared variants for attachment ##{attachment.id}"
      end
    end

    puts "Done! Cleared variants for #{count} attachments."
    puts "Watermarked versions will be generated on next view."
  end

  desc "Pre-generate watermarked variants for all attachments"
  task pregenerate_watermarks: :environment do
    count = 0
    errors = 0

    Attachment.includes(image_attachment: :blob).find_each do |attachment|
      next unless attachment.image.attached?

      begin
        # Generate the watermarked variant
        variant = attachment.image.variant(resize_to_limit: [2048, 2048], watermark: true)
        variant.processed
        count += 1
        puts "Generated watermark for attachment ##{attachment.id}"
      rescue StandardError => e
        errors += 1
        puts "Error processing attachment ##{attachment.id}: #{e.message}"
      end
    end

    puts "Done! Generated #{count} watermarked variants (#{errors} errors)."
  end
end
