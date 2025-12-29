class AddDatabaseConstraints < ActiveRecord::Migration[8.0]
  def change
    # Add NOT NULL constraints to blogs
    change_column_null :blogs, :title, false
    change_column_null :blogs, :published_at, false

    # Add NOT NULL constraint and foreign key for attachments
    change_column_null :attachments, :blog_id, false
    add_foreign_key :attachments, :blogs, on_delete: :cascade
  end
end
