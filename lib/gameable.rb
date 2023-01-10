require_relative 'helpable'

module Gameable
  include Helpable
  
  def games_total_scores_array
    @games.map { |game| total_game_goals(game) }
  end
  
  def percentage_game_wins(side1_goals, side2_goals)
    (@games.find_all { |game| game[side1_goals] > game[side2_goals]}.count.to_f / @games.count).round(2)
  end

  def total_game_goals(game)
    game[:home_goals] + game[:away_goals]
  end
end