require "test_helper"

class AdminHelperTest < ActionView::TestCase
  include AdminHelper

  setup do
    @published_blog = blogs(:spring_garden)
    @scheduled_blog = blogs(:scheduled_post)
  end

  # blog_status_badge tests
  test "blog_status_badge returns nil for published posts" do
    assert_nil blog_status_badge(@published_blog)
  end

  test "blog_status_badge returns scheduled badge for future posts" do
    result = blog_status_badge(@scheduled_blog)

    assert_match "Scheduled", result
    assert_match "status-badge--scheduled", result
  end

  # relative_date tests
  test "relative_date returns dash for nil date" do
    assert_equal "—", relative_date(nil)
  end

  test "relative_date returns Today for today's date" do
    result = relative_date(Time.current)

    assert_match "Today", result
  end

  test "relative_date returns Yesterday for yesterday" do
    result = relative_date(1.day.ago)

    assert_match "Yesterday", result
  end

  test "relative_date returns X days ago for recent dates" do
    result = relative_date(3.days.ago)

    assert_match "3 days ago", result
  end

  test "relative_date returns formatted date for older dates" do
    old_date = 2.months.ago
    result = relative_date(old_date)

    assert_match old_date.strftime("%d %b %Y"), result
  end

  test "relative_date includes time element with datetime attribute" do
    result = relative_date(Time.current)

    assert_match "<time", result
    assert_match "datetime=", result
  end

  # sortable helper is tested via integration tests in admin/blogs_controller_test.rb
end
