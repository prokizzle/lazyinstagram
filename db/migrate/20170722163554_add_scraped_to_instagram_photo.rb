class AddScrapedToInstagramPhoto < ActiveRecord::Migration[5.1]
  def change
    add_column :instagram_photos, :scraped, :boolean
    add_column :instagram_photos, :gender, :string
  end
end
