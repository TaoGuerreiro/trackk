class AddNameToServers < ActiveRecord::Migration[7.0]
  def change
    add_column :servers, :name, :string
  end
end
