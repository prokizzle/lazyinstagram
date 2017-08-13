class CreateUserHashtags < ActiveRecord::Migration[5.1]
  def change
    create_table :user_hashtags do |t|
      t.references :user
      t.references :hashtag
    end
  end
end
