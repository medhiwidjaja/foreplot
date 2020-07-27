require 'foreplot/magiq/ordinal_score'
require 'foreplot/magiq_ranking'

RSpec.describe Foreplot::MagiqRanking do
  let(:choices) { [{id:1, name:'Apple',rank:3}, {id:2, name:'IBM',rank:2}, {id:3, name:'Commodore',rank:1}, {id:4, name:'Atari', rank:5}] }
  let(:expected_result) { 
    [{:id=>3, :name=>"Commodore", :rank=>1, :score=>0.5208333333333334}, {:id=>2, :name=>"IBM", :rank=>2, :score=>0.2708333333333333}, {:id=>1, :name=>"Apple", :rank=>3, :score=>0.14583333333333331}, {:id=>4, :name=>"Atari", :rank=>5, :score=>0}]
  }
  let(:rank_exponential_result) {
    [{:id=>3, :name=>"Commodore", :rank=>1, :score=>0.27991631056633925}, {:id=>2, :name=>"IBM", :rank=>2, :score=>0.26426549301342617}, {:id=>1, :name=>"Apple", :rank=>3, :score=>0.2436813018392995}, {:id=>4, :name=>"Atari", :rank=>5, :score=>0.0}]
  }
  let(:rank_sum_result){
    [{:id=>3, :name=>"Commodore", :rank=>1, :score=>0.4}, {:id=>2, :name=>"IBM", :rank=>2, :score=>0.3}, {:id=>1, :name=>"Apple", :rank=>3, :score=>0.2}, {:id=>4, :name=>"Atari", :rank=>5, :score=>0.0}]
  }
  
  describe ".new" do
    it "creates a valid MagiqRanking object" do
      magiq_ranking = Foreplot::MagiqRanking.new choices
      expect(magiq_ranking.class).to eq(Foreplot::MagiqRanking)
      expect(magiq_ranking.results).to eq([])
    end
  end

  describe ".rank" do
    it "calculates the results" do
      magiq_ranking = Foreplot::MagiqRanking.new choices
      magiq_ranking.rank
      expect(magiq_ranking.rank).to eq(expected_result)
      expect(magiq_ranking.results).to eq(expected_result)
    end
  end

  describe ".rank with rank_sum function" do
    it "calculates the results" do
      magiq_ranking = Foreplot::MagiqRanking.new choices
      results = magiq_ranking.rank :rank_sum
      expect(results).to eq(rank_sum_result)
      expect(magiq_ranking.results).to eq(rank_sum_result)
    end
  end

  describe ".rank with rank_exponential function" do
    it "calculates the results" do
      magiq_ranking = Foreplot::MagiqRanking.new choices
      results = magiq_ranking.rank :rank_exponential
      expect(results).to eq(rank_exponential_result)
      expect(magiq_ranking.results).to eq(rank_exponential_result)
    end
  end

end
