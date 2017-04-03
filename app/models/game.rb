class Game < ActiveRecord::Base
  validates :date_played, :player_one, :player_two, :player_one_score, :player_two_score, presence: true
  validate :date_played_cannot_be_in_the_future, :score_differential_at_least_two, :game_must_be_played_to_21
  belongs_to :player_one, class_name: "User"
  belongs_to :player_two, class_name: "User"

  def calculate_new_ratings
    player_one_rating = player_one.elo
    player_two_rating = player_two.elo

    player_one_result = player_one_score > player_two_score ? 1 : 0
    player_two_result = 1 - player_one_result

    player_one_expectation = 1/(1+10**((player_two.elo - player_one.elo)/400.0))
    player_two_expectation = 1/(1+10**((player_one.elo - player_two.elo)/400.0))

    player_one.elo += (50*(player_one_result - player_one_expectation))
    player_two.elo += (50*(player_two_result - player_two_expectation))

    player_one.save && player_two.save
    return player_one.elo, player_two.elo
  end

  def date_played_cannot_be_in_the_future
    if date_played && date_played > Date.today
      errors.add(:date_played, "can't be in the future")
    end
  end

  def score_differential_at_least_two
    return unless player_one_score && player_two_score
    score_diff = player_one_score - player_two_score
    score_diff *= -1 if score_diff < 0
    if score_diff < 2
      errors.add(:score_differential, "must be at least 2")
    end
  end

  def game_must_be_played_to_21
    return unless player_one_score && player_two_score
    if player_one_score < 21 && player_two_score < 21
      errors.add(:winning_score, "must be at least 21")
    end
    if (player_one_score > 19 && player_two_score > 19) &&
      (player_two_score != player_one_score + 2 && player_two_score != player_one_score - 2)
      errors.add(:games, "must be played to 21 and only continue if not won by 2 points")
    end
  end
end
