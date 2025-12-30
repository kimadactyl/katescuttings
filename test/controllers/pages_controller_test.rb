require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "kate page includes JSON-LD structured data" do
    get kate_url

    assert_response :success
    assert_select "script[type='application/ld+json']", minimum: 1
    assert_match "AboutPage", response.body
    assert_match "Kate Foale", response.body
  end

  test "garden page includes JSON-LD structured data" do
    get garden_url

    assert_response :success
    assert_select "script[type='application/ld+json']", minimum: 1
    assert_match "Place", response.body
    assert_match "Charnwood", response.body
  end

  test "book page includes JSON-LD structured data" do
    get book_url

    assert_response :success
    assert_select "script[type='application/ld+json']", minimum: 1
    assert_match "Book", response.body
  end

  # Accessibility tests - verify all static pages have required accessibility features
  test "kate page has accessibility features" do
    get kate_url

    assert_select "a.skip-link[href='#main-content']"
    assert_select "main#main-content"
    assert_select "nav.navigation[aria-label='Main navigation']"
    assert_select "footer[aria-label='Contact information']"
  end

  test "garden page has accessibility features" do
    get garden_url

    assert_select "a.skip-link[href='#main-content']"
    assert_select "main#main-content"
    assert_select "nav.navigation[aria-label='Main navigation']"
    assert_select "footer[aria-label='Contact information']"
  end

  test "book page has accessibility features" do
    get book_url

    assert_select "a.skip-link[href='#main-content']"
    assert_select "main#main-content"
    assert_select "nav.navigation[aria-label='Main navigation']"
    assert_select "footer[aria-label='Contact information']"
  end
end
