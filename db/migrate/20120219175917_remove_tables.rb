class RemoveTables < ActiveRecord::Migration
  def change
    drop_table :rails_admin_histories
    drop_table :tricks
    drop_table :votes
  end
end
