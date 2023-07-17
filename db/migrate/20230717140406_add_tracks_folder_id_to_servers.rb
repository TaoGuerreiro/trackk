class AddTracksFolderIdToServers < ActiveRecord::Migration[7.0]
  def change
    add_column :servers, :tracks_folder_id, :string
  end
end
