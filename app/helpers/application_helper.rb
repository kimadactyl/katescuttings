module ApplicationHelper
  def markdown(content)
    return "" if content.class != String

    options = {
      autolink: true,
      no_intra_emphasis: true,
      lax_html_blocks: true,
      strikethrough: true,
      superscript: true,
      hard_wrap: true
    }
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, options).render(content).html_safe
  end
end
