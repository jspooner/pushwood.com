class CreateCdPages < ActiveRecord::Migration
  def self.up
    create_table :cd_pages do |t|
      t.string :url
      t.string :guid

      t.timestamps
    end
  end

  def self.down
    drop_table :cd_pages
  end
end
