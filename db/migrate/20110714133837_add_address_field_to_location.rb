class AddAddressFieldToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :address, :text
  end
end
