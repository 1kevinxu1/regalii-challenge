class AddEloToUsers < ActiveRecord::Migration
  def change
    add_column :users, :elo, :integer, default: 1000
    add_index :users, :elo
  end
end
