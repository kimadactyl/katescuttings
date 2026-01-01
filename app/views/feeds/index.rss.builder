xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0",
        "xmlns:atom" => "http://www.w3.org/2005/Atom",
        "xmlns:content" => "http://purl.org/rss/1.0/modules/content/",
        "xmlns:media" => "http://search.yahoo.com/mrss/" do
  xml.channel do
    xml.title "Kate's Cuttings"
    xml.description "Gardening tips, seasonal updates, and photos from Charnwood garden in Nottinghamshire by Kate Foale"
    xml.link root_url
    xml.language "en-gb"
    xml.copyright "#{Date.current.year} Kate Foale"
    xml.lastBuildDate @blogs.first&.updated_at&.to_fs(:rfc822)
    xml.tag! "atom:link", href: rss_feed_url, rel: "self", type: "application/rss+xml"

    xml.image do
      xml.url asset_url("icons/logo-tools.svg")
      xml.title "Kate's Cuttings"
      xml.link root_url
    end

    @blogs.each do |blog|
      xml.item do
        xml.title blog.title
        xml.description truncate(strip_tags(blog.body.to_s), length: 300, separator: " ")
        xml.tag! "content:encoded" do
          # Use body.body.to_html to get raw HTML without ActionText view wrappers
          xml.cdata! blog.body.body&.to_html.to_s
        end
        xml.pubDate blog.published_at.to_fs(:rfc822)
        xml.link blog_url(blog)
        xml.guid blog_url(blog), isPermaLink: "true"
        xml.author "kate@katescuttings.net (Kate Foale)"

        if blog.attachments.any?
          attachment = blog.attachments.first
          if attachment.image.attached?
            # Use proxy URL instead of redirect - RSS readers often don't follow redirects
            variant = attachment.image.variant(resize_to_limit: [800, 800])
            # Get the redirect URL and convert to proxy URL
            redirect_url = rails_representation_url(variant)
            proxy_url = redirect_url.sub("/representations/redirect/", "/representations/proxy/")
            xml.tag! "media:content",
                     url: proxy_url,
                     type: attachment.image.content_type,
                     medium: "image"
          end
        end
      end
    end
  end
end
