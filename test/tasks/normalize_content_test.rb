require "test_helper"
require "rake"

class NormalizeContentTest < ActiveSupport::TestCase
  setup do
    Rails.application.load_tasks
    @blog = blogs(:spring_garden)
  end

  test "converts div tags to p tags" do
    # Set up legacy content with div tags
    @blog.body = ActionText::Content.new("<div>First paragraph</div><div>Second paragraph</div>")
    @blog.save!

    Rake::Task["content:normalize"].reenable
    Rake::Task["content:normalize"].invoke

    @blog.reload

    assert_includes @blog.body.body.to_html, "<p>"
    assert_not_includes @blog.body.body.to_html, "<div>First"
  end

  test "removes spacer divs" do
    # Set up legacy content with spacer divs
    @blog.body = ActionText::Content.new("<div>First paragraph</div><div>&nbsp;</div><div>Second paragraph</div>")
    @blog.save!

    Rake::Task["content:normalize"].reenable
    Rake::Task["content:normalize"].invoke

    @blog.reload
    html = @blog.body.body.to_html

    assert_not_includes html, "<p>&nbsp;</p>"
    assert_not_includes html, "<div>&nbsp;</div>"
  end

  test "removes trailing br tags" do
    @blog.body = ActionText::Content.new("<div>Paragraph with trailing breaks<br><br></div>")
    @blog.save!

    Rake::Task["content:normalize"].reenable
    Rake::Task["content:normalize"].invoke

    @blog.reload
    html = @blog.body.body.to_html

    assert_not_includes html, "<br><br></p>"
  end

  test "leaves proper p tags unchanged" do
    original_html = "<p>Already proper paragraph</p><p>Another one</p>"
    @blog.body = ActionText::Content.new(original_html)
    @blog.save!

    Rake::Task["content:normalize"].reenable
    Rake::Task["content:normalize"].invoke

    @blog.reload

    assert_includes @blog.body.body.to_html, "<p>Already proper paragraph</p>"
  end
end
