class AddIndexToGeoPlanet < ActiveRecord::Migration
  def change
    add_index :geoplanet_places, :country_code
    add_index :geoplanet_places, :name
  end
end