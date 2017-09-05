class AddSuggestedIndexes < ActiveRecord::Migration[5.1]
  def change
      commit_db_transaction
      add_index :instagram_photos, [:gender], algorithm: :concurrently
  end
end
