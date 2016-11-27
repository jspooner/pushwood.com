class FloatToDecmil < ActiveRecord::Migration
  def up
    change_column :locations, :lat, :decimal, :default => 0, :precision => 15, :scale => 8
    change_column :locations, :lng, :decimal, :default => 0, :precision => 15, :scale => 8
  end
end
