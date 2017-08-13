class CreateInstagramUser < ActiveRecord::Migration[5.1]
  def change
    create_table :instagram_users do |t|
      t.string :username
      t.boolean :followed
      t.datetime :last_liked
      t.boolean :ignored
      t.string :instagram_id
      t.integer :user_id, :limit => 8
    end
  end
end
