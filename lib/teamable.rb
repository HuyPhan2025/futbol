require_relative "helpable"

module Teamable
  include Helpable

  def team_game_win_percentages(team_id)
    team_games = @games.select {|game| game.away_team_id == team_id || 
                                       game.home_team_id == team_id}
    
    team_game_teams = team_games.map do |team_game|
      @game_teams.find {|game_team| game_team.game_id == team_game.game_id && 
                                    game_team.team_id != team_id}
    end

    team_game_opponents = team_game_teams.group_by {|team_game_team| team_game_team.team_id}

    team_game_opponents.transform_values do |team_game_opponent|
      opponent_wins = team_game_opponent.count {|game_team| game_team.result == "WIN"}
      opponent_losses = team_game_opponent.count {|game_team| game_team.result == "LOSS"}
      {
        :wins => (opponent_wins / team_game_opponent.count.to_f),
        :losses => (opponent_losses / team_game_opponent.count.to_f)
      }
    end
  end

  def team_info(team_id)
    team = @teams.find { |team| team.team_id == team_id }

    { 
      "team_id" => team.team_id,
      "franchise_id" => team.franchise_id,
      "team_name" => team.team_name,
      "abbreviation" => team.abbreviation,
      "link" => team.link
    }
  end

  def best_season(team_id)
    team_season_win_percentage(team_id).max_by { |season| season[1] }[0]
  end

  def worst_season(team_id)
    team_season_win_percentage(team_id).min_by { |season| season[1] }[0]
  end

  def average_win_percentage(id)
    number_of_winning_games = game_teams_group_by_team_id[id].count do |game|
        game.result == "WIN"
    end
    (number_of_winning_games/game_teams_group_by_team_id[id].count.to_f).round(2)
  end

  def most_goals_scored(team_id)
    game_teams_group_by_team_id[team_id].max_by {|team_game| team_game.goals}.goals
  end

  def fewest_goals_scored(team_id)
    game_teams_group_by_team_id[team_id].min_by {|team_game| team_game.goals}.goals
  end

  def favorite_opponent(team_id)
    favorite_team_id = team_game_win_percentages(team_id).max_by do |team_id, results| 
      results[:losses]
    end.first
    team_name_by_team_id(favorite_team_id)
  end

  def rival(team_id)
    rival_team_id = team_game_win_percentages(team_id).max_by do |team_id, results| 
      results[:wins]
    end.first
    team_name_by_team_id(rival_team_id)
  end  
end