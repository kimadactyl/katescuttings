require 'test_helper'

class BlogsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get blogs_url
    assert_response :success
    assert_select "script[type='application/ld+json']", minimum: 1
  end

  test "should get index as RSS" do
    get blogs_url(format: :rss)
    assert_response :success
    assert_equal "application/rss+xml; charset=utf-8", response.content_type
    assert_match "<rss", response.body
    assert_match "<channel>", response.body
    assert_match "Kate's Cuttings", response.body
  end

  test "should get show" do
    blog = blogs(:spring_garden)
    get blog_url(blog)
    assert_response :success
  end

  test "show page includes JSON-LD structured data" do
    blog = blogs(:spring_garden)
    get blog_url(blog)
    assert_select "script[type='application/ld+json']", minimum: 1
    assert_match "BlogPosting", response.body
    assert_match blog.title, response.body
  end

  test "index page includes RSS auto-discovery link" do
    get blogs_url
    assert_select "link[rel='alternate'][type='application/rss+xml']"
  end
end
