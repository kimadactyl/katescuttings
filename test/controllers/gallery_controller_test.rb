require "test_helper"

class GalleryControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get gallery_url

    assert_response :success
    assert_select "h1", "Gallery"
  end

  test "gallery page has masonry container" do
    get gallery_url

    assert_select ".gallery-page__masonry"
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

  test "gallery has accessibility features" do
    get gallery_url

    assert_select "a.skip-link[href='#main-content']"
    assert_select "main#main-content"
    assert_select "nav.navigation[aria-label='Main navigation']"
  end

  test "navigation includes gallery link on home page" do
    get root_url

    assert_select "nav.navigation a", text: "Gallery"
  end

  test "gallery uses full width layout" do
    get gallery_url

    assert_select "main.layout--full"
  end

  test "gallery wrapped in article tag" do
    get gallery_url

    assert_select "article.gallery-page"
  end
end
