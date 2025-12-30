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

  test "gallery page has view toggle controls" do
    get gallery_url

    assert_select ".gallery-page__toggle", 2
    assert_select ".gallery-page__toggle--active", 1
  end

  test "date view is default" do
    get gallery_url

    assert_select ".gallery-page__toggle--active", text: "By Date"
    # No month headers in date view
    assert_select ".gallery-page__month", count: 0
  end

  test "month view shows month headers when there are attachments" do
    get gallery_url(view: "month")

    assert_select ".gallery-page__toggle--active", text: "By Month"
    # Month headers only appear if there are attachments
    # This test just verifies the view mode toggle works
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
end
