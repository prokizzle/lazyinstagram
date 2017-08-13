class AddIndexToInstagramUsers < ActiveRecord::Migration[5.1]
  def change
  	add_index :instagram_users, :username, :unique => true
  end
end
