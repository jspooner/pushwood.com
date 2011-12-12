class AddBoundingBoxToGeo < ActiveRecord::Migration
  def change
    add_column :geoplanet_places, :bounding_box, :string
  end
end