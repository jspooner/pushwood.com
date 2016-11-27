class AddDataCol < ActiveRecord::Migration
  def self.up
    add_column :cd_pages, :data, :text
  end

  def self.down
    remove_column :cd_pages, :data
  end
end
