require 'foreplot/direct_ranking'
require 'foreplot/direct/smart_score'

RSpec.describe Foreplot::DirectRanking do
  let(:choices) { [{id:1, value:1.0},{id:2, value:4.0},{id:3, value:5.0}] }
  let(:expected_result) { 
    [ {:id=>3, :value=>5.0, :score=>5.0, :score_n=>0.5, :rank=>1}, 
      {:id=>2, :value=>4.0, :score=>4.0, :score_n=>0.4, :rank=>2}, 
      {:id=>1, :value=>1.0, :score=>1.0, :score_n=>0.1, :rank=>3}]
  }
  let(:options_for_range) {
    {range_min: 0.0, range_max: 6.0}
  }
  let(:options_for_minimize) {
    {range_min: 0.0, range_max: 6.0, minimize: true}
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

  context "with options" do
    describe "range" do
      it "calculates the results taking considerating of the provided range" do
        direct_ranking = Foreplot::DirectRanking.new choices, options_for_range
        direct_ranking.rank
        expect(direct_ranking.rank).to eq([
          {:id=>3, :rank=>1, :score=>0.8333333333333334, :score_n=>0.5, :value=>5.0},
          {:id=>2, :rank=>2, :score=>0.6666666666666666, :score_n=>0.39999999999999997, :value=>4.0},
          {:id=>1, :rank=>3, :score=>0.16666666666666666, :score_n=>0.09999999999999999, :value=>1.0}
        ])
      end
    end

    describe "minimize" do
      it "calculates the result, smaller is better" do
        direct_ranking = Foreplot::DirectRanking.new choices, options_for_minimize
        direct_ranking.rank
        expect(direct_ranking.rank).to eq([
          {:id=>1, :rank=>1, :score=>0.8333333333333334, :score_n=>0.6250000000000001, :value=>1.0},
          {:id=>2, :rank=>2, :score=>0.3333333333333333, :score_n=>0.25, :value=>4.0},
          {:id=>3, :rank=>3, :score=>0.16666666666666666, :score_n=>0.125, :value=>5.0}
        ])
      end
    end
  end

end
