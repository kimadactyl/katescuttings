class Blog < ApplicationRecord
  def self.teasers_sorted_by_month(idx = 0)
    blogs = Blog.order(created_at: :desc).limit(10).offset(idx)
    blogs.group_by{ |b| b.created_at.strftime '%B %Y' }
  end

  def self.almanac
    # Get all blogs in reverse date order
    blogs = Blog.order(created_at: :desc).limit(50)
    # Group them into months [["Year", "Month], Blog]]
    months = blogs.group_by{ |b| [b.created_at.strftime('%Y'), b.created_at.strftime('%B')] }
    # Group them into years [["Year"], [["Year", "Month], Blog], ["Year", "Month], Blog]]]
    months.group_by{ |m| m.first.first }
  end

  def formatted_date
    # Add time back in with  - %l:%M%p
    created_at.strftime('%e %B %Y')
  end
end
