namespace :content do
  desc "Normalize blog post HTML to use consistent paragraph spacing"
  task normalize: :environment do
    require "nokogiri"

    Blog.find_each do |blog|
      next if blog.body.blank?

      # Get the raw HTML from ActionText
      original_html = blog.body.body.to_html
      next if original_html.blank?

      # Parse with Nokogiri
      doc = Nokogiri::HTML.fragment(original_html)

      # Track if we made changes
      changed = false

      # Remove spacer divs that only contain &nbsp; or whitespace
      doc.css("div").each do |div|
        text = div.inner_html.strip
        if text == "&nbsp;" || text == "\u00A0" || text.empty?
          div.remove
          changed = true
          next
        end

        # Convert remaining divs to p tags
        inner = div.inner_html
        if inner.end_with?("<br><br>")
          div.inner_html = inner.chomp("<br><br>")
          changed = true
        elsif inner.end_with?("<br>")
          # Single trailing br is also unnecessary with p tags
          div.inner_html = inner.chomp("<br>")
          changed = true
        end

        # Convert div to p
        p_tag = doc.document.create_element("p")
        p_tag.inner_html = div.inner_html
        div.replace(p_tag)
        changed = true
      end

      if changed
        new_html = doc.to_html

        # Update the ActionText body
        blog.body.body = ActionText::Content.new(new_html)
        blog.body.save!

        puts "Normalized: #{blog.slug}"
      end
    end

    puts "Done!"
  end

  desc "Preview what normalize would change (dry run)"
  task normalize_preview: :environment do
    require "nokogiri"

    Blog.find_each do |blog|
      next if blog.body.blank?

      original_html = blog.body.body.to_html
      next if original_html.blank?

      doc = Nokogiri::HTML.fragment(original_html)
      changes = []

      # Check for spacer divs
      doc.css("div").each do |div|
        text = div.inner_html.strip
        changes << "Remove spacer div" if text == "&nbsp;" || text == "\u00A0" || text.empty?

        # Check for divs that should be p tags
        text = div.inner_html.strip
        next if text == "&nbsp;" || text == "\u00A0" || text.empty?

        changes << "Convert div to p"

        inner = div.inner_html
        if inner.end_with?("<br><br>")
          changes << "Remove trailing <br><br>"
        elsif inner.end_with?("<br>")
          changes << "Remove trailing <br>"
        end
      end

      puts "#{blog.slug}: #{changes.uniq.join(", ")}" if changes.any?
    end
  end
end
