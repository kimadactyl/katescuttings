require "application_system_test_case"

class AdminImageUploadTest < ApplicationSystemTestCase
  setup do
    @user = users(:kate)
  end

  test "image upload form has direct upload configured" do
    log_in_as(@user)
    visit new_admin_blog_url

    # Verify the file input has direct_upload attribute which ActiveStorage uses
    file_input = find(".attachment-card__input", visible: :all)
    assert file_input["data-direct-upload-url"].present?,
           "File input should have data-direct-upload-url attribute for ActiveStorage direct uploads"

    # Verify the direct upload URL points to the correct endpoint
    assert_match %r{/rails/active_storage/direct_uploads}, file_input["data-direct-upload-url"],
                 "Direct upload URL should point to ActiveStorage endpoint"
  end
end
