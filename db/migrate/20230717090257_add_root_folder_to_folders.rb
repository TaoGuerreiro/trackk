# frozen_string_literal: true

class AddRootFolderToFolders < ActiveRecord::Migration[7.0]
  def change
    add_column :folders, :root_folder, :boolean
  end
end
