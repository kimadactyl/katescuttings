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

    # HTTP caching - cache for 1 hour, revalidate based on latest attachment
    set_cache_headers
  end

  private

  def months_from_current
    # Cache the rotated months list for the current day
    Rails.cache.fetch("gallery_months_#{Date.current}", expires_in: 1.day) do
      current_month = Date.current.month
      MONTHS.rotate(current_month - 1)
    end
  end

  def set_cache_headers
    # Find the most recently updated attachment for cache validation
    latest_attachment = Attachment.joins(:blog).maximum(:updated_at)
    fresh_when(etag: [latest_attachment, @selected_month, params[:page]], last_modified: latest_attachment)
  end
end
