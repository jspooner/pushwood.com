class AddRatingCacheToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :rating_average, :decimal, :default => 0, :precision => 6, :scale => 2
    Location.reset_column_information
    Location.find_each do |l|
      Location.update_counters l.id, :rating_average => l.images.length
    end
  end
end
