require 'csv'
require_relative 'game'
require_relative 'team'
require_relative 'game_team'

class StatCreator

    def self.create_games(game_path)
        games = []
        CSV.foreach(game_path, headers: true, header_converters: :symbol ) do |info|
          games << Game.new(info)
        end
        games
      end
    
      def self.create_teams(team_path)
        teams = []
        CSV.foreach(team_path, headers: true, header_converters: :symbol ) do |info|
          teams << Team.new(info)
        end
        teams
      end
    
      def self.create_game_teams(game_teams_path)
        game_teams = []
        CSV.foreach(game_teams_path, headers: true, header_converters: :symbol ) do |info|
          game_teams << GameTeam.new(info)
        end
        game_teams
    end

end
