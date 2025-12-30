require "application_system_test_case"

class AccessibilityTest < ApplicationSystemTestCase
  test "home page is accessible" do
    visit root_url
    assert_accessible
  end

  test "blog post page is accessible" do
    blog = blogs(:spring_garden)
    visit blog_url(blog)
    assert_accessible
  end

  test "about kate page is accessible" do
    visit kate_url
    assert_accessible
  end

  test "garden page is accessible" do
    visit garden_url
    assert_accessible
  end

  test "book page is accessible" do
    visit book_url
    assert_accessible
  end
end
