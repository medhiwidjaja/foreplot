require 'rails_helper'

RSpec.describe DirectComparisonCalculator, type: :service do
  let(:direct_comparisons) {
    {"0"=>{"value"=>"4.0"}, 
     "1"=>{"value"=>"1.0"}, 
     "2"=>{"value"=>"5.0"}}
  }

  let(:expected_result) { 
    {"2"=>{"value"=>"5.0", "score"=>"5.0", "score_n"=>"0.5", "rank"=>"1"}, 
     "0"=>{"value"=>"4.0", "score"=>"4.0", "score_n"=>"0.4", "rank"=>"2"}, 
     "1"=>{"value"=>"1.0", "score"=>"1.0", "score_n"=>"0.1", "rank"=>"3"}}
  }

  let(:options_for_range) {
    {range_min: 0.0, range_max: 6.0}
  }
  let(:options_for_minimize) {
    {range_min: 0.0, range_max: 6.0, minimize: true}
  }

  subject { DirectComparisonCalculator.new(direct_comparisons) }

  describe 'call' do
    it 'returns modified hash' do
      expect(subject.call).to eq expected_result
    end

    it 'returns result with range options' do
      calculator = DirectComparisonCalculator.new(direct_comparisons, options_for_range)
      expect(calculator.call).to eq(
        {"2"=>{"value"=>"5.0", "rank"=>"1", "score"=>"0.8333333333333334", "score_n"=>"0.5"},
         "0"=>{"value"=>"4.0", "rank"=>"2", "score"=>"0.6666666666666666", "score_n"=>"0.39999999999999997"},
         "1"=>{"value"=>"1.0", "rank"=>"3", "score"=>"0.16666666666666666", "score_n"=>"0.09999999999999999"}}
      )
    end

    it 'returns result with minimize options' do
      calculator = DirectComparisonCalculator.new(direct_comparisons, options_for_minimize)
      expect(calculator.call).to eq(
        {"1"=>{"value"=>"1.0", "rank"=>"1", "score"=>"0.8333333333333334", "score_n"=>"0.6250000000000001"},
         "0"=>{"value"=>"4.0", "rank"=>"2", "score"=>"0.3333333333333333", "score_n"=>"0.25"},
         "2"=>{"value"=>"5.0", "rank"=>"3", "score"=>"0.16666666666666666", "score_n"=>"0.125"}}
      )
    end
  end
end