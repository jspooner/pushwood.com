class AddEloRank < ActiveRecord::Migration
  def change
    add_column :locations, :elo_rank, :integer
    add_column :images, :elo_rank, :integer
  end
end