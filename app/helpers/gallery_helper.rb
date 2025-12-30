module GalleryHelper
  def caption_with_link(attachment)
    caption = attachment.title.presence || attachment.alt_text.presence || ""
    blog_title = attachment.blog.title
    blog_link = link_to("View post: #{blog_title}", blog_path(attachment.blog), class: "lum-caption-link")

    if caption.present?
      "#{caption}<br>#{blog_link}"
    else
      blog_link
    end
  end
end
