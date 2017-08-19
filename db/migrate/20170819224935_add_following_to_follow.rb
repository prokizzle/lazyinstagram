class AddFollowingToFollow < ActiveRecord::Migration[5.1]
  def change
    add_column :follows, :following, :boolean, default: false
  end
end
