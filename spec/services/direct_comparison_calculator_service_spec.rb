require 'rails_helper'

RSpec.describe DirectComparisonCalculatorService, type: :service do
  let(:direct_comparisons) {
    {"0"=>{"comparable_id"=>"10", "comparable_type"=>"Criterion", "title"=>"C33", "value"=>"76.0", "id"=>"35"}, 
     "1"=>{"comparable_id"=>"9", "comparable_type"=>"Criterion", "title"=>"C32", "value"=>"125.0", "id"=>"37"}, 
     "2"=>{"comparable_id"=>"8", "comparable_type"=>"Criterion", "title"=>"C31", "value"=>"12.0", "id"=>"36"}}
  }

  let(:expected_result) { 
    {"1"=>{"value"=>"125.0", "score"=>"0.5868544600938967", "score_n"=>"0.5868544600938967", "rank"=>"1", "comparable_id"=>"9", "comparable_type"=>"Criterion", "title"=>"C32", "id"=>"37"}, 
     "0"=>{"value"=>"76.0", "score"=>"0.3568075117370892", "score_n"=>"0.3568075117370892", "rank"=>"2", "comparable_id"=>"10", "comparable_type"=>"Criterion", "title"=>"C33", "id"=>"35"}, 
     "2"=>{"value"=>"12.0", "score"=>"0.056338028169014086", "score_n"=>"0.056338028169014086", "rank"=>"3", "comparable_id"=>"8", "comparable_type"=>"Criterion", "title"=>"C31", "id"=>"36"}}
  }

  subject { DirectComparisonCalculatorService.new(direct_comparisons) }

  describe 'call' do
    it 'returns modified hash' do
      expect(subject.call).to eq expected_result
    end
  end
end