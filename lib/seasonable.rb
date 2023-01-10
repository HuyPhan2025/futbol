require_relative 'helpable'

module Seasonable
  include Helpable

  def season_coaches(season)
    season_coach_results = Hash.new { |k,v| k[v] = [] }

    games_by_season[season].each do |season_game|
      game_teams_group_by_game_id[season_game[:game_id]].each do |season_game_team| 
        if season_game_team[:result] == "WIN" 
          season_coach_results[:win] << [season_game[:game_id], season_game_team[:head_coach]] 
        else
          season_coach_results[:loss] << [season_game[:game_id], season_game_team[:head_coach]] 
        end
      end
    end

    season_coach_results
  end

  def season_game_teams(season)
    @game_teams.select { |game_team| game_team[:game_id][0..3] == season[0..3] }
  end

  def tackles_by_season(season)
    tackles_by_season = Hash.new(0)

    game_ids = games_by_season[season].map do |game|
      game[:game_id]
    end

    game_ids.each do |id|
      game_teams_group_by_game_id[id].each do |game_team|
          tackles_by_season[game_team[:team_id]] += game_team[:tackles]
      end
    end

    tackles_by_season
  end

  def team_accuracy(season)
    team_accuracy = {}

    season_games = @game_teams.select {|game_team| game_team[:game_id][0..3] == season[0..3]}
    season_team_ids = season_games.group_by {|season_game| season_game[:team_id]}.keys
  
    season_team_ids.each do |season_team_id|
      team_season_games = season_games.select {|season_game| season_game[:team_id] == season_team_id}
      team_season_goals = team_season_games.sum {|team_season_game| team_season_game[:goals]}
      team_season_shots = team_season_games.sum {|team_season_game| team_season_game[:shots]}
      team_accuracy[season_team_id] = team_season_goals / team_season_shots.to_f 
    end 

    team_accuracy
  end
end