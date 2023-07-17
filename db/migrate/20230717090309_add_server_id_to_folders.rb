# frozen_string_literal: true

class AddServerIdToFolders < ActiveRecord::Migration[7.0]
  def change
    add_reference :folders, :server, null: false, foreign_key: true
  end
end
