class User < ActiveRecord::Base
  validates :elo, presence: true
  devise :database_authenticatable, :registerable, :trackable, :validatable

  def games
    Game.where("player_one_id = ? OR player_two_id = ?", self.id, self.id).order('created_at DESC')
  end

  def opponent(game)
    opponent_id = (self.id == game.player_one_id ? game.player_two_id : game.player_two_id)
    User.find(opponent_id)
  end

  def game_score(game)
    self.id == game.player_one_id ?
      game.player_one_score.to_s + " - " + game.player_two_score.to_s :
      game.player_two_score.to_s + " - " + game.player_one_score.to_s
  end
end
