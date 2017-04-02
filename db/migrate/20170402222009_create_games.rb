class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.date :date_played, null: false
      t.integer  :player_one_id, null: false
      t.integer  :player_two_id, null: false
      t.integer  :player_one_score, null: false
      t.integer  :player_two_score, null: false
      t.timestamps null: false
    end

    add_index :games, :date_played
    add_index :games, :player_one_id
    add_index :games, :player_two_id
    add_index :games, :player_one_score
    add_index :games, :player_two_score
  end
end
