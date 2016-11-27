class AddMarkerVerification < ActiveRecord::Migration
  def change
    add_index :geoplanet_places, :place_type
    add_column :locations, :marker_verified, :boolean
  end
end