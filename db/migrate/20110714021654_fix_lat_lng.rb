class FixLatLng < ActiveRecord::Migration
  def up
    change_column :locations, :lat, :float, :default => 0, :precision => 9, :scale => 8
    change_column :locations, :lng, :float, :default => 0, :precision => 9, :scale => 8
  end

  def down
  end
end
