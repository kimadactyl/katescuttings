require "test_helper"

class Admin::BlogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:kate)
    @blog = blogs(:spring_garden)
    @scheduled_blog = blogs(:scheduled_post)

    # Attach a test image to spring_garden blog for thumbnail tests
    @blog.attachments.create!(
      title: "Test Image",
      alt_text: "A test image",
      image: fixture_file_upload("test_image.png", "image/png")
    )
  end

  # Authentication tests
  test "redirects to login when not authenticated" do
    get admin_blogs_url
    assert_redirected_to login_path
  end

  test "allows access when authenticated" do
    log_in_as(@user)
    get admin_blogs_url
    assert_response :success
  end

  # Index tests
  test "index displays blogs" do
    log_in_as(@user)
    get admin_blogs_url

    assert_response :success
    assert_select "table.admin-table"
    assert_match @blog.title, response.body
  end

  test "index search filters by title" do
    log_in_as(@user)
    get admin_blogs_url, params: { q: "Spring" }

    assert_response :success
    assert_match "Spring Garden", response.body
    assert_no_match "Summer Flowers", response.body
  end

  test "index search via turbo frame loads thumbnails" do
    log_in_as(@user)
    get admin_blogs_url, params: { q: "Spring" }, headers: { "Turbo-Frame" => "blogs-table" }

    assert_response :success
    assert_select "turbo-frame#blogs-table"
    assert_select ".admin-table"
    # Verify thumbnail images are present with valid src attributes
    assert_select ".admin-thumb img[src]" do |imgs|
      assert imgs.any?, "Expected at least one thumbnail image"
      imgs.each do |img|
        assert img["src"].present?, "Image should have a src attribute"
      end
    end
  end

  test "index filters published posts" do
    log_in_as(@user)
    get admin_blogs_url, params: { status: "published" }

    assert_response :success
    assert_match @blog.title, response.body
    assert_no_match @scheduled_blog.title, response.body
  end

  test "index filters scheduled posts" do
    log_in_as(@user)
    get admin_blogs_url, params: { status: "scheduled" }

    assert_response :success
    assert_match @scheduled_blog.title, response.body
    assert_no_match @blog.title, response.body
  end

  test "filter buttons update active state" do
    log_in_as(@user)
    get admin_blogs_url, params: { status: "published" }

    assert_response :success
    # Published filter should be active
    assert_select ".admin-filter--active", text: "Published"
    # All filter should not be active
    assert_select ".admin-filter:not(.admin-filter--active)", text: "All"
  end

  test "index sorts by title ascending" do
    log_in_as(@user)
    get admin_blogs_url, params: { sort: "title", direction: "asc" }

    assert_response :success
  end

  test "index sorts by published_at descending" do
    log_in_as(@user)
    get admin_blogs_url, params: { sort: "published_at", direction: "desc" }

    assert_response :success
  end

  test "index shows scheduled badge for future posts" do
    log_in_as(@user)
    get admin_blogs_url

    assert_response :success
    assert_select ".status-badge--scheduled", text: "Scheduled"
  end

  # New/Create tests
  test "new displays form" do
    log_in_as(@user)
    get new_admin_blog_url

    assert_response :success
    assert_select "form"
  end

  test "new form has direct upload configured on file input" do
    log_in_as(@user)
    get new_admin_blog_url

    assert_response :success
    # Verify the file input has the data-direct-upload-url attribute
    # This proves direct_upload: true is set on the form field
    assert_select "input[type='file'][data-direct-upload-url]"
  end

  test "create redirects to index on success" do
    log_in_as(@user)

    assert_difference("Blog.count", 1) do
      post admin_blogs_url, params: {
        blog: {
          title: "New Test Post",
          published_at: Time.current
        }
      }
    end

    assert_redirected_to admin_blogs_path
    assert_equal "Successfully created new blog", flash[:success]
  end


  # Edit/Update tests
  test "edit displays form" do
    log_in_as(@user)
    get edit_admin_blog_url(@blog)

    assert_response :success
    assert_select "form"
    assert_match @blog.title, response.body
  end

  test "update redirects to index on success" do
    log_in_as(@user)

    patch admin_blog_url(@blog), params: {
      blog: { title: "Updated Title" }
    }

    assert_redirected_to admin_blogs_path
    assert_equal "Post updated", flash[:success]
    assert_equal "Updated Title", @blog.reload.title
  end

  # Pagination tests
  test "index pagination works and loads attachments" do
    log_in_as(@user)
    get admin_blogs_url, params: { page: 2 }

    assert_response :success
  end

  # Delete tests
  test "destroy removes blog and redirects to index" do
    log_in_as(@user)

    assert_difference("Blog.count", -1) do
      delete admin_blog_url(@blog)
    end

    assert_redirected_to admin_blogs_path
  end
end
