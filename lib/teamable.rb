require_relative "helpable"

module Teamable
  include Helpable

  def team_game_win_percentages(team_id)
    team_games = @games.select {|game| game.away_team_id == team_id || 
    game.home_team_id == team_id}
    
    team_game_teams = team_games.map do |team_game|
      @game_teams.find {|game_team| game_team.game_id == team_game.game_id && game_team.team_id != team_id}
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
end