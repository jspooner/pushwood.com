class UpdateLocation < ActiveRecord::Migration
  def self.up
    rename_column :locations, :are_pads_required, :pads_required
  end

  def self.down
    rename_column :locations, :pads_required, :are_pads_required
  end
end


