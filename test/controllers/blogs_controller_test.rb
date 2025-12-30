require "test_helper"

class BlogsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get blogs_url

    assert_response :success
    assert_select "script[type='application/ld+json']", minimum: 1
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

  test "pagination links use HTML format not XML" do
    get root_url

    assert_response :success
    # Pagination links should go to root path, not index.xml
    assert_no_match %r{href="/index\.xml\?page=}, response.body
    assert_no_match %r{href="[^"]*\.xml[^"]*page=}, response.body
  end

  test "pagination links work correctly" do
    get root_url(page: 2)

    assert_response :success
  end
end
