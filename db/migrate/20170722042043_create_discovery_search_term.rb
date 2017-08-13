class CreateDiscoverySearchTerm < ActiveRecord::Migration[5.1]
  def change
    create_table :discovery_search_terms do |t|
      t.string :search_term
      t.integer :radius
    end
  end
end
