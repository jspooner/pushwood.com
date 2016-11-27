class AddTokenToAuthenications < ActiveRecord::Migration
  def change
    add_column :authentications, :token, :string
  end
end