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

  # Accessibility tests (HTML structure)
  test "index page has skip link" do
    get blogs_url

    assert_select "a.skip-link[href='#main-content']", text: "Skip to main content"
  end

  test "index page has main content target" do
    get blogs_url

    assert_select "main#main-content"
  end

  test "navigation has aria label" do
    get blogs_url

    assert_select "nav.navigation[aria-label='Main navigation']"
  end

  test "footer has aria label" do
    get blogs_url

    assert_select "footer[aria-label='Contact information']"
  end

  test "almanac sidebar has aria label and screen reader heading" do
    get blogs_url

    assert_select ".almanac[aria-label='Browse articles by date']"
    assert_select ".almanac h2.sr-only", text: "Browse by Date"
  end

  test "blog titles use h2 headings" do
    get blogs_url

    assert_select ".teaser h2.teaser__title"
  end

  test "month labels are paragraphs not headings" do
    get blogs_url

    assert_select "p.teaser__month"
    # Should not have h3 or any heading for months
    assert_select "h3.teaser__month", count: 0
  end
end
