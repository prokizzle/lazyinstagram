class CreateUserLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :user_locations do |t|
      t.references :user
      t.references :location
    end
  end
end
