class CreateTricks < ActiveRecord::Migration
  def self.up
    create_table :tricks do |t|
      t.integer :user_id
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.string :lat
      t.string :lng

      t.timestamps
    end
  end

  def self.down
    drop_table :tricks
  end
end
