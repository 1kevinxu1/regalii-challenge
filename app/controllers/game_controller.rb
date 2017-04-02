class GameController < ApplicationController
  def create
    @game = Game.new(game_params.merge(player_one_id: current_user.id))
    if @game.save
      redirect_to log_url
      flash[:notice] = "Game successfully logged"
    else
      flash.now[:errors] = @game.errors.full_messages
      render "home/log"
    end
  end

  private

  def game_params
    params.require(:game).permit(:date_played, :player_one_score, :player_two_score, :player_two_id)
  end
end
