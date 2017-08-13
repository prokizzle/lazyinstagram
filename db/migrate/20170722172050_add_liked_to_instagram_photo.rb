class AddLikedToInstagramPhoto < ActiveRecord::Migration[5.1]
  def change
    add_column :instagram_photos, :liked, :boolean, default: false
  end
end
