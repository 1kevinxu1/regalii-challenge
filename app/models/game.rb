class Game < ActiveRecord::Base
  validates :date_played, :player_one, :player_two, :player_one_score, :player_two_score, presence: true
  validate :date_played_cannot_be_in_the_future, :score_differential_at_least_two, :game_must_be_played_to_21
  belongs_to :player_one, class_name: "User"
  belongs_to :player_two, class_name: "User"

  def date_played_cannot_be_in_the_future
    if date_played > Date.today
      errors.add(:date_played, "can't be in the future")
    end
  end

  def score_differential_at_least_two
    score_diff = player_one_score - player_two_score
    score_diff *= -1 if score_diff < 0
    if score_diff < 2
      errors.add(:score_differential, "must be at least 2")
    end
  end

  def game_must_be_played_to_21
    if player_one_score < 21 && player_two_score < 21
      errors.add(:winning_score, "must be at least 21")
    end
  end
end
