class AddLastQueryToDiscoverySearchTerm < ActiveRecord::Migration[5.1]
  def change
    add_column :discovery_search_terms, :last_query, :timestamp
  end
end
