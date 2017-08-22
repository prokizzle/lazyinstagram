class AddScrapedIndexToInstagramPhoto < ActiveRecord::Migration[5.1]
  def change
      add_index :instagram_photos, :scraped
      add_index :instagram_photos, [:liked, :scraped]
      add_index :instagram_photos, :liked
  end
end
