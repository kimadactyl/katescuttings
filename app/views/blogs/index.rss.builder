xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0", "xmlns:atom" => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.title "Kate's Cuttings"
    xml.description "A gardening blog by Kate Foale from Nottinghamshire, UK"
    xml.link root_url
    xml.language "en-gb"
    xml.tag! "atom:link", href: rss_feed_url, rel: "self", type: "application/rss+xml"

    @blogs.each do |blog|
      xml.item do
        xml.title blog.title
        xml.description CGI.unescapeHTML(strip_tags(blog.body.to_s).truncate(500))
        xml.pubDate blog.published_at.to_fs(:rfc822)
        xml.link blog_url(blog)
        xml.guid blog_url(blog)
      end
    end
  end
end
