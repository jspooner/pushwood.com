class AddImageCaption < ActiveRecord::Migration
  def change
    add_column :images, :caption, :string
  end
end