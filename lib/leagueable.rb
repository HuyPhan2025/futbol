require_relative 'helpable'

module Leagueable
  include Helpable

  def percent_team_goals
    percent_team_goals = game_teams_group_by_team_id.transform_values do |games_by_team| 
      total_goals = games_by_team.sum do |game|
        game.goals
      end
      (total_goals.to_f/games_by_team.count).round(2)
    end
  end

  def away_teams_average_scoring_hash
    away_scores_hash = Hash.new(0)
    away_teams_average_scoring_hash = {}
    
    @games.each do |game|
      away_scores_hash[game.away_team_id] += (game.away_goals.to_f)
    end
  
    away_scores_hash.each do |away_id, score_value|
      away_games_per_team.each do |games_id, game_value|
        if games_id == away_id
          away_teams_average_scoring_hash[away_id] = (score_value/game_value).round(2)
        end
      end
    end
    away_teams_average_scoring_hash
  end

  def away_games_per_team
    @games.map { |game| game.away_team_id }.tally
  end

  def home_teams_average_scoring_hash
    home_scores_hash = Hash.new(0)
    home_teams_average_scoring_hash = {}
    
    @games.each do |game|
      home_scores_hash[game.home_team_id] += (game.home_goals.to_f)
    end
    
    home_scores_hash.each do |home_id, score_value|
      home_games_per_team.each do |games_id, game_value|
        if games_id == home_id
          home_teams_average_scoring_hash[home_id] = (score_value/game_value).round(2)
        end
      end
    end
    home_teams_average_scoring_hash
  end

  def home_games_per_team
    number_of_games = []
    @games.map do |game|
      number_of_games << game.home_team_id
    end
    number_of_games.tally
  end

  def team_season_win_percentage(team_id)
    team_games = @games.select { |game| game.away_team_id == team_id || game.home_team_id == team_id }
    team_season_games = team_games.group_by { |team_game| team_game.season }
    
    team_season_game_teams = team_season_games.transform_values do |team_season_games|
      team_season_games.map do |team_season_game| 
        game_teams.find { |game_team| game_team.game_id == team_season_game.game_id &&
                                                    game_team.team_id == team_id }
      end
    end

    team_season_game_teams.transform_values do |team_season_game_teams|
      team_season_game_teams.count { |team_season_game_team| team_season_game_team.result == "WIN" }.to_f / team_season_game_teams.count
    end
  end
end