require_relative 'helpable'

module Gameable
  include Helpable
  
  def games_total_scores_array
    @games.map { |game| total_game_goals(game) }
  end
  
  def total_game_goals(game)
    game.home_goals + game.away_goals
  end

  def highest_total_score
    games_total_scores_array.max
  end

  def lowest_total_score
    games_total_scores_array.min
  end

  def percentage_home_wins
    (@games.find_all { |game| game.home_goals > game.away_goals}.count.to_f / @games.count).round(2)
  end

  def percentage_visitor_wins
    (@games.find_all { |game| game.home_goals < game.away_goals}.count.to_f / @games.count).round(2)
  end

  def percentage_ties
    (@games.find_all { |game| game.away_goals == game.home_goals}.count.to_f / @games.count).round(2)
  end

  def count_of_games_by_season
    games_by_season.transform_values(&:size)
  end

  def average_goals_per_game
    (@games.sum { |game| total_game_goals(game) } / @games.count.to_f).round(2)
  end
  
  def average_goals_by_season
    games_by_season.transform_values do |games|
      (games.sum { |game| total_game_goals(game) } / games.size.to_f).round(2)
    end
  end  
end