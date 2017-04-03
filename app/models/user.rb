class User < ActiveRecord::Base
  validates :elo, presence: true
  devise :database_authenticatable, :registerable, :trackable, :validatable
  attr_accessor :rank

  def self.get_all_by_rank
    rank = 1
    cur_elo = nil
    user_by_rank = User.all.order("elo DESC").each do |user|
      rank += 1 if cur_elo && user.elo < cur_elo
      cur_elo = user.elo
      user.rank = rank
    end
    user_by_rank
  end

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
