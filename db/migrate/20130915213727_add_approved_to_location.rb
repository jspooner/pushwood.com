class AddApprovedToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :approved, :boolean, default: false
  end
end