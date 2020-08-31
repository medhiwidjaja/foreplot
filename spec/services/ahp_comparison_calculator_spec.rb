require 'rails_helper'

RSpec.describe AHPComparisonCalculator, type: :service do
  let(:choices) { [{"id"=>1, "name"=>"Apple"}, {"id"=>2, "name"=>"Atari"}, {"id"=>3, "name"=>"Commodore"}] }
  let(:decision_matrix) { [0.25, 4, 9] }
  let(:expected_result) { 
    { 
      "2" => { "comparable_id" => "2", "score"=>"0.7170650412287761",  "score_n"=>"0.7170650412287761",  "rank"=>"1" }, 
      "1" => { "comparable_id" => "1", "score"=>"0.2171656088028061",  "score_n"=>"0.2171656088028061",  "rank"=>"2" }, 
      "3" => { "comparable_id" => "3", "score"=>"0.06576934996841792", "score_n"=>"0.06576934996841792", "rank"=>"3" } 
    }
  }
  let(:expected_cr) { 0.03180650067105072 }
  let(:pairwise_comparisons) {
    {
      "0" => {"comparable1_id" => "1", "comparable2_id" => "2", "value" => "0.25"},
      "1" => {"comparable1_id" => "1", "comparable2_id" => "3", "value" => "4"},
      "2" => {"comparable1_id" => "2", "comparable2_id" => "3", "value" => "9"}
    }
  }

  subject { AHPComparisonCalculator.new(pairwise_comparisons, choices) }

  describe 'call' do
    it 'returns modified hash' do
      expect(subject.call).to eq expected_result
    end
  end

  describe 'consistency ratio' do
    it 'returns cr' do
      expect(subject.cr).to eq expected_cr
    end
  end
end