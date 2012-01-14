class AddApprovedImages < ActiveRecord::Migration
  def change
    add_column :images, :approved, :boolean, :default => 0
    Image.find_each do |image|
      image.update_attribute :approved, true
    end
  end
end