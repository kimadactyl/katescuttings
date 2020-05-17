class Blog < ApplicationRecord
  validates :title, :published_at, presence: true
  has_rich_text :body
  has_many :attachments
  accepts_nested_attributes_for :attachments,
    allow_destroy: true,
    reject_if: :all_blank

  scope :teasers, -> { order(published_at: :desc) }

  def self.in_month(year, month)
    start_date = DateTime.new(year.to_i, month.to_i)
    end_date = start_date + 1.month
    Blog.where('published_at >= ? AND published_at < ?', start_date, end_date)
  end

  def self.almanac
    # Get all blogs in reverse date order
    blogs = Blog.order(published_at: :desc).limit(50)
    # Group them into months [["Year", "Month], Blog]]
    months = blogs.group_by { |b| [b.published_at.strftime('%Y'), b.published_at.strftime('%m')] }
    # Group them into years [["Year"], [["Year", "Month], Blog], ["Year", "Month], Blog]]]
    months.group_by { |m| m.first.first }
  end

  def formatted_date
    # Add time back in with  - %l:%M%p
    published_at.strftime('%e %B %Y')
  end
end
