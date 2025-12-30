xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do
  # Homepage
  xml.url do
    xml.loc root_url
    xml.changefreq "weekly"
    xml.priority "1.0"
  end

  # Static pages
  %w[kate garden book].each do |page|
    xml.url do
      xml.loc send("#{page}_url")
      xml.changefreq "monthly"
      xml.priority "0.7"
    end
  end

  # Blog posts
  @blogs.each do |blog|
    xml.url do
      xml.loc blog_url(blog)
      xml.lastmod blog.updated_at.strftime("%Y-%m-%d")
      xml.changefreq "monthly"
      xml.priority "0.8"
    end
  end
end
