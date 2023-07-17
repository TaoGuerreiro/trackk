# frozen_string_literal: true

class CreateDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :documents do |t|
      t.string :name
      t.string :drive_file_id
      t.references :folder, null: false, foreign_key: true

      t.timestamps
    end
  end
end
