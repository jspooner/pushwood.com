class AddRelationShipToCdPage < ActiveRecord::Migration
  def self.up
    add_column :locations, :cd_page_id, :integer
  end

  def self.down
    remove_column :locations, :cd_page_id
  end
end
