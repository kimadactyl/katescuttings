class Blog < ApplicationRecord
  validates :title, presence: true
  has_many_attached :images

  scope :teasers, -> { order(created_at: :desc) }

  def self.in_month(year, month)
    start_date = DateTime.new(year.to_i, month.to_i)
    end_date = start_date + 1.month
    Blog.where('created_at >= ? AND created_at < ?', start_date, end_date)
  end

  def self.almanac
    # Get all blogs in reverse date order
    blogs = Blog.order(created_at: :desc).limit(50)
    # Group them into months [["Year", "Month], Blog]]
    months = blogs.group_by { |b| [b.created_at.strftime('%Y'), b.created_at.strftime('%m')] }
    # Group them into years [["Year"], [["Year", "Month], Blog], ["Year", "Month], Blog]]]
    months.group_by { |m| m.first.first }
  end

  def formatted_date
    # Add time back in with  - %l:%M%p
    created_at.strftime('%e %B %Y')
  end
end
