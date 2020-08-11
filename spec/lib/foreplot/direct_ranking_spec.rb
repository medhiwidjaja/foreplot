require 'foreplot/direct_ranking'

RSpec.describe Foreplot::DirectRanking do
  let(:choices) { [{id:1, value:1.0},{id:2, value:4.0},{id:3, value:5.0}] }
  let(:expected_result) { 
    [{:id=>3, :value=>5.0, :score=>0.5, :score_n=>0.5, :rank=>1}, {:id=>2, :value=>4.0, :score=>0.4, :score_n=>0.4, :rank=>2}, {:id=>1, :value=>1.0, :score=>0.1, :score_n=>0.1, :rank=>3}]
  }

  
  describe ".new" do
    it "creates a valid DirectRanking object" do
      direct_ranking = Foreplot::DirectRanking.new choices
      expect(direct_ranking.class).to eq(Foreplot::DirectRanking)
      expect(direct_ranking.results).to eq([])
    end
  end

  describe ".rank" do
    it "calculates the results" do
      direct_ranking = Foreplot::DirectRanking.new choices
      direct_ranking.rank
      expect(direct_ranking.rank).to eq(expected_result)
      expect(direct_ranking.results).to eq(expected_result)
    end
  end

end
