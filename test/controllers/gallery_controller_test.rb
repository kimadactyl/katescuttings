require "test_helper"

class GalleryControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get gallery_url

    assert_response :success
    assert_select "h1", "Gallery"
  end

  test "gallery page has masonry container" do
    get gallery_url

    assert_select "section.gallery-page__masonry"
  end

  test "gallery page has month filter buttons" do
    get gallery_url

    # Should have All button plus 12 month buttons
    assert_select ".gallery-page__filter", 13
    assert_select ".gallery-page__filter--active", text: "All"
  end

  test "default view shows all images" do
    get gallery_url

    assert_select ".gallery-page__filter--active", text: "All"
    assert_select ".gallery-page__showing", count: 0
  end

  test "month filter shows filtered results" do
    get gallery_url(month: "January")

    assert_select ".gallery-page__filter--active", text: "Jan"
    assert_select ".gallery-page__showing", /January/
  end

  test "gallery uses full width layout" do
    get gallery_url

    assert_select "main.layout--full"
  end

  test "gallery wrapped in article tag" do
    get gallery_url

    assert_select "article.gallery-page"
  end

  # Accessibility tests
  test "gallery has skip link and main content" do
    get gallery_url

    assert_select "a.skip-link[href='#main-content']"
    assert_select "main#main-content"
  end

  test "filter navigation has aria label" do
    get gallery_url

    assert_select "nav.gallery-page__filters[aria-label='Filter by month']"
  end

  test "active filter has aria-current" do
    get gallery_url

    assert_select ".gallery-page__filter--active[aria-current='page']"
  end

  test "month filters have aria-labels" do
    get gallery_url

    # Check one of the month buttons has an aria-label
    assert_select ".gallery-page__filter[aria-label^='Filter by']"
  end

  test "gallery section has aria label" do
    get gallery_url

    assert_select "section.gallery-page__masonry[aria-label='Photo gallery']"
  end

  test "filtered view has aria-live region" do
    get gallery_url(month: "January")

    assert_select ".gallery-page__showing[aria-live='polite']"
  end

  test "navigation includes gallery link" do
    get root_url

    assert_select "nav.navigation a", text: "Gallery"
  end

  # Caching tests
  test "gallery sets cache headers" do
    get gallery_url

    assert_response :success
    assert response.headers["ETag"].present?
  end

  test "gallery returns 304 on conditional GET with matching etag" do
    get gallery_url
    etag = response.headers["ETag"]

    get gallery_url, headers: { "If-None-Match" => etag }

    assert_response :not_modified
  end
end
