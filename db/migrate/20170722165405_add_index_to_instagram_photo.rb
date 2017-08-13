class AddIndexToInstagramPhoto < ActiveRecord::Migration[5.1]
  def change
  	add_index :instagram_photos, :url, :unique => true
  	add_index :instagram_photos, [:url, :photo_id, :user_id]
  end
end
