module Helpable
  def games_by_season
    @games_by_season ||= @games.group_by { |game| game.season }
  end

  def game_teams_group_by_game_id
    @game_teams_group_by_game_id ||= @game_teams.group_by { |game_team| game_team.game_id }
  end

  def game_teams_group_by_team_id
    @game_teams_group_by_team_id ||= @game_teams.group_by { |game_team| game_team.team_id }
  end

  def team_name_by_team_id(team_id)
    @teams.find {|team| team.team_id == team_id }.team_name
  end
end