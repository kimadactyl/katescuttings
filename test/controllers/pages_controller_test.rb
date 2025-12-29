require 'test_helper'

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
end
