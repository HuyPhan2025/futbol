require 'csv'
require_relative 'gameable'
require_relative 'leagueable'
require_relative 'seasonable'
require_relative 'teamable'

class StatTracker
  include Gameable, Leagueable, Seasonable, Teamable
  attr_reader :games, :teams, :game_teams

  def initialize(locations)
    @games = create_games(locations[:games])
    @teams = create_teams(locations[:teams])
    @game_teams = create_game_teams(locations[:game_teams])
  end

  def create_games(game_path)
    games = []
    CSV.foreach(game_path, headers: true, header_converters: :symbol ) do |info|
      game = info.to_h
      game[:away_goals] = game[:away_goals].to_i
      game[:home_goals] = game[:home_goals].to_i
      games << game
    end
    games
  end

  def create_teams(team_path)
    teams = []
    CSV.foreach(team_path, headers: true, header_converters: :symbol ) do |info|
      teams << info.to_h
    end
    teams
  end

  def create_game_teams(game_teams_path)
    game_teams = []
    CSV.foreach(game_teams_path, headers: true, header_converters: :symbol ) do |info|
      game_team = info.to_h
      game_team[:goals] = game_team[:goals].to_i
      game_team[:shots] = game_team[:shots].to_i
      game_team[:tackles] = game_team[:tackles].to_i
      game_team[:pim] = game_team[:pim].to_i
      game_team[:powerplayopportunities] = game_team[:powerplayopportunities].to_i
      game_team[:powerplaygoals] = game_team[:powerplaygoals].to_i
      game_team[:faceoffwinpercentage] = game_team[:faceoffwinpercentage].to_f
      game_team[:giveaways] = game_team[:giveaways].to_i
      game_team[:takeaways] = game_team[:takeaways].to_i
      game_teams << game_team
    end
    game_teams
  end

  def self.from_csv(locations)
    new(locations)
  end

  def highest_total_score
    games_total_scores_array.max
  end

  def lowest_total_score
    games_total_scores_array.min
  end

  def percentage_home_wins
    percentage_game_wins(:home_goals, :away_goals)
  end

  def percentage_visitor_wins
    percentage_game_wins(:away_goals, :home_goals)
  end

  def percentage_ties
    (@games.find_all { |game| game[:away_goals] == game[:home_goals]}.count.to_f / @games.count).round(2)
  end

  def average_goals_per_game
    (@games.sum { |game| total_game_goals(game) } / @games.count.to_f).round(2)
  end
  
  def average_goals_by_season
    hash = Hash.new{0}
    
    games_by_season.each do |season, games|
      games.each { |game| hash[season] += total_game_goals(game) }      
      hash[season] = (hash[season]/games.size.to_f).round(2)
    end

    hash
  end        
     
  def count_of_teams
    @teams.length
  end

  def count_of_games_by_season
    count_of_games_by_season = {}
    games_by_season.each { |season, games| count_of_games_by_season[season] = games.size }
    count_of_games_by_season
  end
    
  def highest_scoring_visitor
    highest_id = away_teams_average_scoring_hash.max_by { |away_team| away_team[1] }.first
    team_name_by_team_id(highest_id)
  end  
    
  def lowest_scoring_visitor
    lowest_id = away_teams_average_scoring_hash.min_by { |away_team| away_team[1] }.first
    team_name_by_team_id(lowest_id)
  end
  
  def highest_scoring_home_team
    highest_id = home_teams_average_scoring_hash.max_by { |home_team| home_team[1] }.first
    team_name_by_team_id(highest_id)
  end

  def lowest_scoring_home_team
    lowest_id = home_teams_average_scoring_hash.min_by { |home_team| home_team[1] }.first
    team_name_by_team_id(lowest_id)
  end

  def most_tackles(season)
    team_with_most_tackles = tackles_by_season(season).max_by { |team_tackles| team_tackles[1] }.first
    team_name_by_team_id(team_with_most_tackles)
  end

  def fewest_tackles(season)
    team_with_least_tackles = tackles_by_season(season).min_by { |team_tackles| team_tackles[1] }.first
    team_name_by_team_id(team_with_least_tackles)
  end

  def average_win_percentage(id)
    number_of_winning_games = game_teams_group_by_team_id[id].count do |game|
        game[:result] == "WIN"
    end
    (number_of_winning_games/game_teams_group_by_team_id[id].count.to_f).round(2)
  end

  def best_offense    
    best_offense_id = percent_team_goals.max_by { |percent_team_goal| percent_team_goal[1]}.first
    team_name_by_team_id(best_offense_id)
  end

  def worst_offense    
    worst_offense_id = percent_team_goals.min_by { |percent_team_goal| percent_team_goal[1]}.first
    team_name_by_team_id(worst_offense_id)
  end

  def most_accurate_team(season)  
    best_team = team_accuracy(season).max_by {|team| team[1]}[0]
    team_name_by_team_id(best_team)
  end

  def least_accurate_team(season)
    worst_team = team_accuracy(season).min_by {|team| team[1]}[0]
    team_name_by_team_id(worst_team)
  end
  
  def most_goals_scored(team_id)
    game_teams_group_by_team_id[team_id].max_by {|team_game| team_game[:goals]}[:goals]
  end

  def fewest_goals_scored(team_id)
    game_teams_group_by_team_id[team_id].min_by {|team_game| team_game[:goals]}[:goals]
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
 
  def winningest_coach(season)
    season_coaches(season)[:win].group_by(&:last).map { |coach, win_game_ids| [win_game_ids.size, coach] }.max.last
  end

  def worst_coach(season)
    season_coaches(season)[:loss].group_by(&:last).map { |coach, win_game_ids| [win_game_ids.size, coach] }.min.last
  end

  def best_season(team_id)
    team_season_win_percentage(team_id).max_by { |season| season[1] }[0]
  end

  def worst_season(team_id)
    team_season_win_percentage(team_id).min_by { |season| season[1] }[0]
  end

  def team_info(team_id)
    team = @teams.find { |team| team[:team_id] == team_id }

    { 
      "team_id" => team[:team_id],
      "franchise_id" => team[:franchiseid],
      "team_name" => team[:teamname],
      "abbreviation" => team[:abbreviation],
      "link" => team[:link]
    }
  end
end
