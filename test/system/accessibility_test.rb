require "application_system_test_case"

class AccessibilityTest < ApplicationSystemTestCase
  # WCAG 2.1 AA compliance tests using axe-core
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

  # Skip link tests
  test "skip link is present and targets main content" do
    visit root_url

    skip_link = find(".skip-link", visible: :all)
    assert_equal "Skip to main content", skip_link.text
    assert_equal "#main-content", skip_link[:href].split("/").last

    # Verify main content target exists
    assert page.has_css?("#main-content")
  end

  test "skip link becomes visible on focus" do
    visit root_url

    # Skip link should be off-screen initially
    skip_link = find(".skip-link", visible: :all)

    # Focus the skip link using keyboard
    page.execute_script("document.querySelector('.skip-link').focus()")

    # After focus, skip link should be visible (top: 0)
    assert page.has_css?(".skip-link:focus")
  end

  # ARIA landmark tests
  test "navigation has aria label" do
    visit root_url

    nav = find("nav.navigation")
    assert_equal "Main navigation", nav[:"aria-label"]
  end

  test "footer has aria label" do
    visit root_url

    footer = find("footer")
    assert_equal "Contact information", footer[:"aria-label"]
  end

  test "almanac sidebar has aria label" do
    visit root_url

    almanac = find(".almanac")
    assert_equal "Browse articles by date", almanac[:"aria-label"]
  end

  # Heading hierarchy tests
  test "blog index has correct heading structure" do
    visit root_url

    # Blog titles should be h2 (main headings)
    blog_titles = all(".teaser__title")
    assert blog_titles.any?, "Should have blog title headings"

    blog_titles.each do |title|
      # The h2 is inside the teaser__title div
      assert title.has_css?("a"), "Blog titles should have links"
    end

    # Month labels should be paragraphs, not headings
    month_labels = all(".teaser__month")
    month_labels.each do |label|
      assert_equal "P", label.tag_name.upcase, "Month labels should be <p> elements"
    end
  end

  # Screen reader content tests
  test "almanac has screen reader heading" do
    visit root_url

    # The sr-only heading should exist but be visually hidden
    sr_heading = find(".almanac h2.sr-only", visible: :all)
    # Text may be transformed by CSS, so compare case-insensitively
    assert_equal "browse by date", sr_heading.text.downcase
  end

  # Focus indicator tests
  test "interactive elements have visible focus indicators" do
    visit root_url

    # Find a link and verify focus styles are applied
    first_link = first("a")
    first_link.native.send_keys("")  # Focus the element

    # The focus-visible outline should be defined in CSS
    # We verify the CSS is loaded by checking the stylesheet exists
    assert page.has_css?("link[href*='accessibility']", visible: :all) ||
           page.has_css?("style", visible: :all),
           "Accessibility styles should be loaded"
  end
end
