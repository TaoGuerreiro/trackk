# frozen_string_literal: true

class CreateServers < ActiveRecord::Migration[7.0]
  def change
    create_table :servers do |t|
      t.string :token
      t.string :root_folder_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
