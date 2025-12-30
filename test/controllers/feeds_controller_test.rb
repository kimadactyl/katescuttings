require "test_helper"

class FeedsControllerTest < ActionDispatch::IntegrationTest
  test "should get RSS feed" do
    get rss_feed_url

    assert_response :success
    assert_equal "application/rss+xml; charset=utf-8", response.content_type
    assert_match "<rss", response.body
    assert_match "<channel>", response.body
    assert_match "Kate's Cuttings", response.body
  end

  test "RSS feed includes blog posts" do
    blog = blogs(:spring_garden)
    get rss_feed_url

    assert_response :success
    assert_match blog.title, response.body
  end
end
