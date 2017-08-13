class CreateInstagramPhoto < ActiveRecord::Migration[5.1]
  def change
    create_table :instagram_photos do |t|
      t.string :photo_id
      t.string :url
      t.integer :user_id, limit: 8
    end
  end
end
