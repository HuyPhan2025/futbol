require './lib/gameable'

RSpec.describe Gameable do
  let(:game) {Game.new(game_id:"2013020105", 
                       season:"20132014", 
                       type:"Regular Season", 
                       date_time:"10/18/13", 
                       away_team_id:"26", 
                       home_team_id:"18", 
                       away_goals:"1", 
                       home_goals:"1", 
                       venue:"Allianz Field", 
                       venue_link:"/api/v1/venues/null")}
  let(:stat_tracker) {double("stat_tracker").extend(Gameable)}
  
  describe 'gameable helper methods' do
    it '#total game goals' do      
      expect(stat_tracker.total_game_goals(game)).to eq(2)
    end

    it '#games_total_scores_array' do
      game_array = [game]

      allow(stat_tracker).to receive(:games).and_return(game_array)
      expect(stat_tracker.games_total_scores_array).to eq([2])
    end
  end
end