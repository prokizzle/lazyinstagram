class ChangeInstagramIdType < ActiveRecord::Migration[5.1]
  def change
  	change_column :locations, :instagram_id, :string
  end
end
