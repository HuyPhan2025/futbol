require_relative 'helpable'

module Gameable
  include Helpable
  
  def games_total_scores_array
    games.map { |game| total_game_goals(game) }
  end
  
  def total_game_goals(game)
    game.home_goals + game.away_goals
  end
end