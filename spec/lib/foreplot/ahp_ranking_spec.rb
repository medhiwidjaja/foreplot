require 'foreplot/ahp/ahp_matrix'
require 'foreplot/ahp/analytic_hierarchy_process'
require 'foreplot/ahp_ranking'

RSpec.describe Foreplot::AHPRanking do
  let(:choices) { [{id:1, name:'Apple',rank:3}, {id:2, name:'IBM',rank:2}, {id:3, name:'Commodore',rank:1}, {id:4, name:'Atari', rank:5}] }
  let(:decision_matrix) { [0.25, 4, 0.16666666666666666, 4, 0.25, 0.2] }
  let(:expected_result) { 
    [ {:id=>4, :name=>"Atari", :rank=>1, :score=>0.5772610243960814, :score_n=>0.5772610243960814}, {:id=>2, :name=>"IBM", :rank=>2, :score=>0.24685232558282658, :score_n=>0.24685232558282658}, {:id=>1, :name=>"Apple", :rank=>3, :score=>0.11587161681891035, :score_n=>0.11587161681891035}, {:id=>3, :name=>"Commodore", :rank=>4, :score=>0.06001503320218165, :score_n=>0.06001503320218165} ]
  }
  let(:expected_cr) { 0.16099725957623498 }
  
  describe ".new" do
    it "creates a valid AHPRanking object" do
      ahp_ranking = Foreplot::AHPRanking.new choices, decision_matrix
      expect(ahp_ranking.class).to eq(Foreplot::AHPRanking)
      expect(ahp_ranking.results).to eq([])
    end
  end

  describe ".rank" do
    it "calculates the results" do
      ahp_ranking = Foreplot::AHPRanking.new choices, decision_matrix
      ahp_ranking.rank
      expect(ahp_ranking.rank).to eq(expected_result)
      expect(ahp_ranking.results).to eq(expected_result)
    end
  end

  describe ".consistency_ratio" do
    it "returns the consistency ratio" do
      ahp_ranking = Foreplot::AHPRanking.new choices, decision_matrix
      expect(ahp_ranking.consistency_ratio).to eq(expected_cr)
    end
  end

end
