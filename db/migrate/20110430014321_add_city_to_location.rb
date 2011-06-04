class AddCityToLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :street, :string
    add_column :locations, :postal, :string
    add_column :locations, :city, :string
    add_column :locations, :state, :string
    add_column :locations, :country, :string
  end

  def self.down
    remove_column :locations, :country
    remove_column :locations, :state
    remove_column :locations, :city
    remove_column :locations, :postal
    remove_column :locations, :street
  end
end
