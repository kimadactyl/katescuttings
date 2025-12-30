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

  test "RSS feed is valid XML" do
    get rss_feed_url

    assert_response :success
    # Parse XML - will raise if invalid
    doc = Nokogiri::XML(response.body)
    assert doc.errors.empty?, "RSS feed has XML errors: #{doc.errors.join(', ')}"
  end

  test "RSS feed does not contain ActionText debug comments" do
    get rss_feed_url

    assert_response :success
    # Ensure no ActionText view wrapper comments leak into RSS
    assert_no_match(/<!-- BEGIN.*actiontext/i, response.body)
    assert_no_match(/<!-- END.*actiontext/i, response.body)
    assert_no_match(/class="trix-content"/, response.body)
  end

  test "RSS feed has required elements" do
    get rss_feed_url

    doc = Nokogiri::XML(response.body)
    # Required RSS 2.0 channel elements
    assert doc.at_xpath("//channel/title"), "RSS feed missing channel title"
    assert doc.at_xpath("//channel/link"), "RSS feed missing channel link"
    assert doc.at_xpath("//channel/description"), "RSS feed missing channel description"

    # Each item should have required elements
    items = doc.xpath("//item")
    assert items.any?, "RSS feed has no items"
    items.each do |item|
      assert item.at_xpath("title"), "RSS item missing title"
      assert item.at_xpath("link"), "RSS item missing link"
      assert item.at_xpath("guid"), "RSS item missing guid"
    end
  end
end
