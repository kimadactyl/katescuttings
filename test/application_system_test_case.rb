require "test_helper"
require "axe-capybara"
require "axe/matchers/be_axe_clean"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include OmniAuthTestHelper

  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  # Assert page is accessible according to WCAG 2.1 AA + best practices
  def assert_accessible
    matcher = Axe::Matchers::BeAxeClean.new.according_to(:wcag21aa, :"best-practice")
    audit_result = matcher.audit(page)
    assert(audit_result.passed?, audit_result.failure_message)
  end

  # Log in as a user via OmniAuth mock (uses visit instead of get for system tests)
  def log_in_as(user)
    mock_omniauth_for(user)
    visit "/auth/google_oauth2/callback"
  end
end
