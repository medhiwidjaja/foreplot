require 'rails_helper'

RSpec.describe DirectComparisonCalculatorService, type: :service do
  let(:direct_comparisons) {
    {"0"=>{"value"=>"4.0"}, 
     "1"=>{"value"=>"1.0"}, 
     "2"=>{"value"=>"5.0"}}
  }

  let(:expected_result) { 
    {"2"=>{"value"=>"5.0", "score"=>"0.5", "score_n"=>"0.5", "rank"=>"1"}, 
     "0"=>{"value"=>"4.0", "score"=>"0.4", "score_n"=>"0.4", "rank"=>"2"}, 
     "1"=>{"value"=>"1.0", "score"=>"0.1", "score_n"=>"0.1", "rank"=>"3"}}
  }

  subject { DirectComparisonCalculatorService.new(direct_comparisons) }

  describe 'call' do
    it 'returns modified hash' do
      expect(subject.call).to eq expected_result
    end
  end
end