class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :location_id
      t.string :img_file_name
      t.string :img_content_type
      t.string :img_file_size
      t.datetime :img_updated_at

      t.timestamps
    end
  end
end
