class Blog < ApplicationRecord
  extend FriendlyId

  friendly_id :title, use: :slugged

  validates :title, :published_at, presence: true
  validates :slug, uniqueness: true
  has_rich_text :body
  has_many :attachments, dependent: :destroy

  after_commit :expire_almanac_cache

  private

  def expire_almanac_cache
    Rails.cache.delete("blog_almanac")
  end

  public

  accepts_nested_attributes_for :attachments,
                                allow_destroy: true,
                                reject_if: :all_blank

  scope :teasers, -> { order(published_at: :desc) }

  def prev
    b = Blog.order(published_at: :desc)
            .where(published_at: ...published_at)
            .limit(1)
    b.length == 1 ? b[0] : false
  end

  def next
    b = Blog.order(published_at: :asc)
            .where("published_at > ?", published_at)
            .limit(1)
    b.length == 1 ? b[0] : false
  end

  def self.in_month(year, month)
    start_date = DateTime.new(year.to_i, month.to_i)
    end_date = start_date + 1.month
    Blog.where(published_at: start_date...end_date)
  end

  def self.almanac
    # Get all blogs in reverse date order (no limit - show all years)
    blogs = Blog.order(published_at: :desc).includes(:attachments)
    # Group them into months [["Year", "Month], Blog]]
    months = blogs.group_by { |b| [b.published_at.strftime("%Y"), b.published_at.strftime("%m")] }
    # Group them into years [["Year"], [["Year", "Month], Blog], ["Year", "Month], Blog]]]
    months.group_by { |m| m.first.first }
  end

  def formatted_date
    # Add time back in with  - %l:%M%p
    published_at.strftime("%e %B %Y")
  end
end
