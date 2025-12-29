class AddAltTextToAttachments < ActiveRecord::Migration[8.0]
  def change
    add_column :attachments, :alt_text, :string
  end
end
