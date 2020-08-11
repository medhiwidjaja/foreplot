require 'rails_helper'

RSpec.describe MagiqComparisonCalculatorService, type: :service do
  let(:magiq_comparisons) {
    {"0"=>{"rank"=>"2"}, 
     "1"=>{"rank"=>"3"}, 
     "2"=>{"rank"=>"1"}}
  }
  let(:expected_result) { 
    {"2"=>{"rank"=>"1", "score"=>"0.611111111111111"}, 
     "0"=>{"rank"=>"2", "score"=>"0.27777777777777773"}, 
     "1"=>{"rank"=>"3", "score"=>"0.1111111111111111"}}
  }

  subject { MagiqComparisonCalculatorService.new(magiq_comparisons) }

  describe 'call' do
    it 'returns modified hash' do
      expect(subject.call).to eq expected_result
    end
  end
end