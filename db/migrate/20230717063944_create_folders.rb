# frozen_string_literal: true

class CreateFolders < ActiveRecord::Migration[7.0]
  def change
    create_table :folders do |t|
      t.string :name
      t.integer :parent_folder_id
      t.string :webhook_url
      t.string :drive_folder_id
      t.string :channel_id
      t.string :resource_id

      t.timestamps
    end
  end
end
