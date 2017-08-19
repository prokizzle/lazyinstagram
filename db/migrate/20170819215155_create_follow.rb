class CreateFollow < ActiveRecord::Migration[5.1]
  def change
    create_table :follows do |t|
      t.string :user_id
      t.datetime :followed_at
      t.integer :follows, default: 0
      t.boolean :followed_back, default: false
    end
  end
end
