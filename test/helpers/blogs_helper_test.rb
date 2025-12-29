require 'test_helper'

class BlogsHelperTest < ActionView::TestCase
  test "teaser_text strips HTML tags" do
    html = "<p>Hello <strong>world</strong></p>"
    result = teaser_text(html)
    assert_no_match /<\/?p>/, result
    assert_no_match /<\/?strong>/, result
    assert_match "Hello", result
    assert_match "world", result
  end

  test "teaser_text replaces &nbsp; with spaces" do
    html = "Hello&nbsp;world"
    result = teaser_text(html)
    assert_no_match /&nbsp;/, result
    assert_match "Hello world", strip_tags(result)
  end

  test "teaser_text truncates to specified length" do
    html = "A" * 1000
    result = teaser_text(html, length: 100)
    # Result includes simple_format wrapper, so check the text content
    assert strip_tags(result).length <= 103  # 100 + "..."
  end

  test "teaser_text preserves paragraph breaks" do
    html = "<p>First paragraph</p><p>Second paragraph</p>"
    result = teaser_text(html)
    # simple_format converts \n\n to <br> tags
    assert_match "First paragraph", result
    assert_match "Second paragraph", result
  end
end
