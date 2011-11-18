class AddImageCountToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :images_count, :integer
    Location.reset_column_information
      Location.find_each do |l|
        Location.update_counters l.id, :images_count => l.images.length
      end
  end
end