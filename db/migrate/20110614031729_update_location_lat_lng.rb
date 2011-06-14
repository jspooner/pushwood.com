class UpdateLocationLatLng < ActiveRecord::Migration
  def self.up
    change_table :locations do |t|
      t.change :lat, :float
      t.change :lng, :float
    end
  end

  def self.down
    change_table :locations do |t|
      t.change :lat, :text
      t.change :lng, :text
    end    
  end
end
