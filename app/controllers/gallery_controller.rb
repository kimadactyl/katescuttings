class GalleryController < ApplicationController
  IMAGES_PER_PAGE = 60
  EAGER_LOAD_COUNT = 15

  # Month names starting from current month
  MONTHS = Date::MONTHNAMES.compact.freeze

  def index
    @selected_month = params[:month].presence
    @months = months_from_current

    base_query = Attachment
      .joins(:blog)
      .includes(:blog, image_attachment: :blob)
      .where.not(blogs: { published_at: nil })

    if @selected_month.present?
      # Filter by month name (all years), no pagination
      month_number = Date::MONTHNAMES.index(@selected_month)
      @attachments = base_query
        .where("EXTRACT(MONTH FROM blogs.published_at) = ?", month_number)
        .order(Arel.sql("blogs.published_at DESC, attachments.id ASC"))
      @paginated = false
    else
      # All images, reverse chronological, paginated
      @attachments = base_query
        .order(Arel.sql("blogs.published_at DESC, attachments.id ASC"))
        .page(params[:page])
        .per(IMAGES_PER_PAGE)
      @paginated = true
    end

    @eager_load_count = EAGER_LOAD_COUNT
  end

  private

  def months_from_current
    current_month = Date.current.month
    # Rotate months so current month is first
    MONTHS.rotate(current_month - 1)
  end
end
