module AdminHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = (column == params[:sort] && params[:direction] == "asc") ? "desc" : "asc"
    arrow = if column == params[:sort]
              params[:direction] == "asc" ? " ▲" : " ▼"
            else
              ""
            end
    link_to(title + arrow, request.params.merge(sort: column, direction: direction), class: "sortable")
  end

  def blog_status_badge(blog)
    return nil unless blog.published_at&.future?

    tag.span("Scheduled", class: "status-badge status-badge--scheduled")
  end

  def relative_date(date)
    return "—" if date.nil?

    days_ago = (Time.current.to_date - date.to_date).to_i

    text = case days_ago
           when 0 then "Today"
           when 1 then "Yesterday"
           when 2..6 then "#{days_ago} days ago"
           when 7..13 then "1 week ago"
           when 14..29 then "#{days_ago / 7} weeks ago"
           else date.strftime("%d %b %Y")
           end

    tag.time(text, datetime: date.iso8601, title: date.strftime("%d %B %Y at %H:%M"))
  end
end
