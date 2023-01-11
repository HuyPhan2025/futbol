require_relative 'spec_helper'

RSpec.describe StatTracker do
  let(:game_path) {'./spec/fixtures/games.csv'}
  let(:team_path) {'./spec/fixtures/teams.csv'}
  let(:game_teams_path) {'./spec/fixtures/game_teams.csv'}
  let(:locations) do
    {
    games: game_path,
    teams: team_path,
    game_teams: game_teams_path
    }
  end

  let(:stat_tracker) { StatTracker.from_csv(locations) }
  
  describe "#initialize" do
    it 'exists' do
      expect(StatTracker.from_csv(locations)).to be_an_instance_of(StatTracker)
    end
  end

  describe '#highest_total_score' do
    it 'can get highest total score' do
      expect(stat_tracker.highest_total_score).to eq(7)
    end
  end

  describe '#lowest_total_score' do
    it 'can get lowest total score' do
      expect(stat_tracker.lowest_total_score).to eq(2)
    end
  end

  describe '#games_total_scores_array' do
    it 'returns array of total scores' do
      expect(stat_tracker.games_total_scores_array.first).to be_a(Integer)
      expect(stat_tracker.games_total_scores_array).to be_a(Array)
    end
  end

  describe '#percentage_home_wins' do
    it "can return percentage of home wins" do
      expect(stat_tracker.percentage_home_wins).to eq 0.40
    end
  end

  describe '#percentage_visitor_wins' do
    it "can return percentage of home wins" do
      expect(stat_tracker.percentage_visitor_wins).to eq 0.50
    end
  end
  
  describe '#percentage_ties' do
    it "can return percentage of ties" do
      expect(stat_tracker.percentage_ties).to eq 0.10
    end
  end

  describe '#average_goals_per_game or season' do
    it 'can find average goals per game' do
      expect(stat_tracker.average_goals_per_game).to eq(3.7)
    end

    it 'can find average goals by season' do
      expected_hash = 
        {
          "20132014" => 4.0,
          "20122013" => 3.33,
          "20162017" => 3.0,
          "20152016" => 4.0
        }

      expect(stat_tracker.average_goals_by_season).to eq(expected_hash)
    end
  end

  describe '#count_of_teams' do
    it 'returns total number of teams in data' do
      expect(stat_tracker.count_of_teams).to eq(12)
    end
  end

  describe '#count_of_games_by_season' do
    it '#count_of_games_by_season' do
      expected = {
        "20132014"=>3,
        "20122013"=>3,
        "20162017"=>1,
        "20152016"=>3,
      }

      expect(stat_tracker.count_of_games_by_season).to eq(expected)
    end
  end

  describe '#highest_ and lowest_scoring_visitor' do
    it 'can find highest scoring visitor' do
      expect(stat_tracker.highest_scoring_visitor).to eq("FC Dallas")
    end

    it 'can find lowest scoring visitor' do
      expect(stat_tracker.lowest_scoring_visitor).to eq("LA Galaxy").or(eq("FC Cincinnati"))
    end
  end

  describe '#highest_ and lowest_scoring_home_team' do
    it 'can find highest scoring home team' do
      expect(stat_tracker.highest_scoring_home_team).to eq("North Carolina Courage")
    end

    it 'can find the lowest scoring home team' do
      expect(stat_tracker.lowest_scoring_home_team).to eq("FC Dallas").or(eq("Minnesota United FC")).or(eq("Montreal Impact"))
    end
  end

  describe '#most_tackles and #fewest_tackles' do
    it 'can find most_tackles' do
      expect(stat_tracker.most_tackles("20132014")).to eq("North Carolina Courage")
    end

    it 'can find fewest_tackles' do
      expect(stat_tracker.fewest_tackles("20132014")).to eq("FC Cincinnati")
    end
  end

  describe '#average_win_percentage' do
    it 'can find average_win_percentage for a team' do
      expect(stat_tracker.average_win_percentage("6")).to eq(0.33)
    end
  end

  describe 'best and worst offense' do
    it 'can find best_offense' do
      expect(stat_tracker.best_offense).to eq("North Carolina Courage")
    end

    it 'can find the worst_offense' do
      expect(stat_tracker.worst_offense).to eq("FC Cincinnati")
    end
  end

  describe '#winningest_coach' do
    it 'can return the coach with the best win percentage for a season' do
      expect(stat_tracker.winningest_coach("20152016")).to eq("Michel Therrien")
    end
  end

  describe '#worst_coach' do
    it 'can return the coach with the worst win percentage for a season' do
      expect(stat_tracker.worst_coach("20152016")).to eq("Jeff Blashill").or(eq("Claude Julien")) 
    end
  end

  describe '#best_season' do
    it 'can return the best season for a team' do
      expect(stat_tracker.best_season("6")).to eq("20122013")
    end
  end

  describe '#worst_season' do
    it 'can return the worst season for a team' do
      expect(stat_tracker.worst_season("6")).to eq("20152016")
    end
  end

  describe '#team_info' do
    it "can return team info" do
      expected = {
        "team_id" => "26",
        "franchise_id" => "14",
        "team_name" => "FC Cincinnati",
        "abbreviation" => "CIN",
        "link" => "/api/v1/teams/26"
      }

      expect(stat_tracker.team_info("26")).to eq(expected)
    end
  end

  describe '#most_accurate_team' do
    it "can return the name of the most accurate team" do
      expect(stat_tracker.most_accurate_team("20162017")).to eq ("Real Salt Lake")
      expect(stat_tracker.most_accurate_team("20122013")).to eq ("FC Dallas")
    end
  end

  describe '#least_accurate_team' do
    it "can return the name of the least accurate team" do
      expect(stat_tracker.least_accurate_team("20162017")).to eq ("Montreal Impact")
      expect(stat_tracker.least_accurate_team("20122013")).to eq ("Seattle Sounders FC")
    end
  end

  describe '#most_goals_scored' do
    it "can return the most goals scored by a team in a game" do
      expect(stat_tracker.most_goals_scored("6")).to eq 4
    end
  end

  describe '#fewest_goals_scored' do
    it "can return the fewest goals scored by a team in a game" do
      expect(stat_tracker.fewest_goals_scored("6")).to eq 1
    end
  end

  describe '#favorite_opponent' do
    it "can return the name of the favorite opponent" do
      expect(stat_tracker.favorite_opponent("6")).to eq ("Sporting Kansas City")
    end
  end

  describe '#rival' do
    it "can return the name of the rival opponent" do
      expect(stat_tracker.rival("6")).to eq("New York Red Bulls")
    end
  end

  describe 'Helper Methods' do
    describe '#games_total_scores_array' do
      it 'can return an array of total scores' do
        expect(stat_tracker.games_total_scores_array).to eq([2, 3, 2, 3, 5, 3, 5, 4, 3, 7])
      end
    end

    describe '#total_game_goals' do
      it 'can return total number of goals in a game' do
        game = stat_tracker.games[0]

        expect(stat_tracker.total_game_goals(game)).to eq(2)
      end
    end

    describe '#percent_team_goals' do
      it 'can return hash of percent goals by team' do
        expected = {
          "26"=>1.0, "18"=>1.0, 
          "17"=>1.0, "16"=>2.0, 
          "2"=>1.5, "5"=>1.5, 
          "24"=>2.0, "23"=>1.0, 
          "6"=>2.0, "8"=>2.33, 
          "13"=>2.5, "10"=>4.0
        }

        expect(stat_tracker.percent_team_goals).to eq(expected)
      end
    end

    describe '#away_teams_average_scoring_hash' do
      it 'can return hash of away average score per team' do
        expected = {
          "26"=>1.0, "17"=>1.0,
          "2"=>1.5, "24"=>2.0, 
          "6"=>4.0, "8"=>2.5, 
          "13"=>3.0
        }

        expect(stat_tracker.away_teams_average_scoring_hash).to eq(expected)
      end
    end

    describe '#away_games_per_team' do
      it 'can return number of away games per team' do
        expected = {
          "26"=>1, "17"=>2, 
          "2"=>2, "24"=>1, 
          "6"=>1, "8"=>2, "13"=>1
        }

        expect(stat_tracker.away_games_per_team).to eq(expected)
      end
    end

    describe '#home_teams_average_scoring_hash' do
      it 'can return hash of home average score per team' do
        expected = {
          "18"=>1.0, "16"=>2.0, 
          "5"=>1.5, "23"=>1.0, 
          "8"=>2.0, "13"=>2.0, 
          "6"=>1.0, "10"=>4.0
        }

        expect(stat_tracker.home_teams_average_scoring_hash).to eq(expected)
      end
    end

    describe '#home_games_per_team' do
      it 'can return number of home games per team' do
        expected = {
          "18"=>1, "16"=>1, 
          "5"=>2, "23"=>1, 
          "8"=>1, "13"=>1, 
          "6"=>2, "10"=>1
        }

        expect(stat_tracker.home_games_per_team).to eq(expected)
      end
    end

    describe '#team_season_win_percentage' do
      it 'can return a hash of season win percentages for a team' do
        expected = { "20122013"=>1.0, "20152016"=>0.0, "20132014"=>0.0 }

        expect(stat_tracker.team_season_win_percentage("6")).to eq(expected)
      end
    end

    describe '#season_coaches' do
      it 'returns a hash of wins and losses per game with coach' do
        expected = {
          :win=>[["2016021135", "Randy Carlyle"]], 
          :loss=>[["2016021135", "Willie Desjardins"]]
        }
        
        expect(stat_tracker.season_coaches("20162017")).to eq(expected)
      end
    end

    describe '#tackles_by_season' do
      it 'can return number of tackles by season' do
        expected = {
          "17"=>25, "16"=>22, 
          "2"=>27, "5"=>70, 
          "6"=>19
        }

        expect(stat_tracker.tackles_by_season("20122013")).to eq(expected)
      end
    end

    describe '#team_accuracy' do
      it 'can return a hash of each teams accuracy for given season' do
        expected = {
          "17"=>0.1667, "16"=>0.1818, 
          "2"=>0.0, "5"=>0.2308, 
          "6"=>0.5714
        }

        expect(stat_tracker.team_accuracy("20122013"))
      end
    end
    
    describe '#team_game_win_percentages' do
      it 'returns a hash of opponents and number of losses and wins' do
        expected = {
          "5"=>{:wins=>0.0, :losses=>1.0}, 
          "8"=>{:wins=>1.0, :losses=>0.0}
        }

        expect(stat_tracker.team_game_win_percentages("6")).to eq(expected)
      end
    end

    describe '#team_name_by_team_id' do
      it 'can return team name for a given team id' do
        expect(stat_tracker.team_name_by_team_id("6")).to eq("FC Dallas")
      end
    end
  end
end