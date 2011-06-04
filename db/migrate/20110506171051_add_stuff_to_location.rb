class AddStuffToLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :lat, :string
    add_column :locations, :lng, :string
    add_column :locations, :phone, :string
    add_column :locations, :has_lights, :tinyint, :default => 0
    add_column :locations, :is_free, :tinyint, :default => 0
    add_column :locations, :is_outdoors, :tinyint, :default => 0
    add_column :locations, :are_pads_required, :tinyint, :default => 0
    add_column :locations, :has_concrete, :tinyint, :default => 0
    add_column :locations, :has_wood, :tinyint, :default => 0
  end

  def self.down
    remove_column :locations, :has_wood
    remove_column :locations, :has_concrete
    remove_column :locations, :are_pads_required
    remove_column :locations, :is_outdoors
    remove_column :locations, :is_free
    remove_column :locations, :has_lights
    remove_column :locations, :phone
    remove_column :locations, :lng
    remove_column :locations, :lat
  end
end
