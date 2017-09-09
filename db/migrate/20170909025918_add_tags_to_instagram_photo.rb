class AddTagsToInstagramPhoto < ActiveRecord::Migration[5.1]
  def change
    add_column :instagram_photos, :tags, :string, array: true, default: '{}'
  end
end
