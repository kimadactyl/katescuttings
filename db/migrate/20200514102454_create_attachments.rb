class CreateAttachments < ActiveRecord::Migration[6.0]
  def change
    create_table :attachments do |t|
      t.string :title
      t.datetime :taken_at
      t.belongs_to :blog
      t.timestamps
    end
  end
end
