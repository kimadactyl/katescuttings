require "test_helper"

class ActiveStorageConfigTest < ActiveSupport::TestCase
  test "application.js imports and starts ActiveStorage" do
    js_content = File.read(Rails.root.join("app/javascript/application.js"))

    # Verify ActiveStorage is imported as a module (not just side-effect import)
    assert_match(/import \* as ActiveStorage from ["']@rails\/activestorage["']/, js_content,
                 "application.js should import ActiveStorage as a module")

    # Verify ActiveStorage.start() is called to initialize direct upload handlers
    assert_match(/ActiveStorage\.start\(\)/, js_content,
                 "application.js should call ActiveStorage.start() to enable direct uploads")
  end
end
