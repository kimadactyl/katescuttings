module BlogsHelper
  def teaser_text(body, length: 600)
    text = body.to_s
    # Convert block elements to newlines before stripping
    text = text.gsub(%r{</p>|</div>}i, "\n\n")
    text = text.gsub(%r{<br\s*/?>}i, "\n")
    # Replace &nbsp; entities before stripping (handles both encoded and literal)
    text = text.gsub(/&nbsp;/i, " ")
    # Strip remaining HTML tags
    text = strip_tags(text)
    # Unescape HTML entities
    text = CGI.unescapeHTML(text)
    # Replace non-breaking spaces with regular spaces
    text = text.gsub("\u00A0", " ")
    # Clean up excess whitespace
    text = text.gsub(/[^\S\n]+/, " ").gsub(/\n{3,}/, "\n\n").strip
    # Truncate
    text = truncate(text, length: length, separator: " ")
    # Return with paragraph formatting
    simple_format(text, {}, wrapper_tag: "span")
  end
end
