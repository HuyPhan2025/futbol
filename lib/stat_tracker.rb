require_relative 'stat_creator'
require_relative 'gameable'
require_relative 'leagueable'
require_relative 'seasonable'
require_relative 'teamable'

class StatTracker
  include Gameable, Leagueable, Seasonable, Teamable
  attr_reader :games, :teams, :game_teams

  def initialize(locations)
    @games = StatCreator.create_games(locations[:games])
    @teams = StatCreator.create_teams(locations[:teams])
    @game_teams = StatCreator.create_game_teams(locations[:game_teams])
  end

  def self.from_csv(locations)
    new(locations)
  end   
end
