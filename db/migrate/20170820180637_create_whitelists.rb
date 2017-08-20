class CreateWhitelists < ActiveRecord::Migration[5.1]
  def change
    create_table :whitelists do |t|
      t.integer :user_id
      t.string :instagram_user_id
      t.string :instagram_username
      t.string :instagram_photo
      t.timestamps
    end
  end
end
