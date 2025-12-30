class GalleryController < ApplicationController
  def index
    @view_mode = params[:view].presence || "date"

    base_query = Attachment
      .joins(:blog)
      .includes(:blog, image_attachment: :blob)
      .where.not(blogs: { published_at: nil })

    if @view_mode == "month"
      # Group by month name (all Decembers together, etc.), ordered by date within each month
      @attachments_by_month = base_query
        .order(Arel.sql("EXTRACT(MONTH FROM blogs.published_at) DESC, blogs.published_at DESC, attachments.id ASC"))
        .group_by { |a| a.blog.published_at.strftime("%B") }
    else
      # Simple reverse chronological order
      @attachments = base_query
        .order(Arel.sql("blogs.published_at DESC, attachments.id ASC"))
    end
  end
end
