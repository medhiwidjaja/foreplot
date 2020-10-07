require 'rails_helper'

RSpec.describe AHPComparisonCalculator, type: :service do
  let(:choices) { [
    {"id"=>1, "name"=>"Apple", "comparable_id" => 11, "comparable_type" => "Alternative"}, 
    {"id"=>2, "name"=>"Atari", "comparable_id" => 12, "comparable_type" => "Alternative"}, 
    {"id"=>3, "name"=>"Commodore", "comparable_id" => 13, "comparable_type" => "Alternative"}
  ] }
  let(:expected_result) { 
    { 
      "2" => { "id" => "2", "comparable_id" => "12", "comparable_type" => 'Alternative', "score"=>"0.7170650412287761",  "score_n"=>"0.7170650412287761",  "rank"=>"1", "title"=>"Atari"}, 
      "1" => { "id" => "1", "comparable_id" => "11", "comparable_type" => 'Alternative', "score"=>"0.2171656088028061",  "score_n"=>"0.2171656088028061",  "rank"=>"2", "title"=>"Apple" }, 
      "3" => { "id" => "3", "comparable_id" => "13", "comparable_type" => 'Alternative', "score"=>"0.06576934996841792", "score_n"=>"0.06576934996841792", "rank"=>"3", "title"=>"Commodore" } 
    }
  }
  let(:expected_cr) { 0.03180650067105072 }
  let(:pairwise_comparisons) {
    {
      "0" => {"comparable1_id" => "11", "comparable2_id" => "12", "value" => "0.25"},
      "1" => {"comparable1_id" => "11", "comparable2_id" => "13", "value" => "4"},
      "2" => {"comparable1_id" => "12", "comparable2_id" => "13", "value" => "9"}
    }
  }
  let(:unordered_comparisons) {
    {
      "0" => {"comparable1_id" => "12", "comparable2_id" => "13", "value" => "9"},
      "1" => {"comparable1_id" => "11", "comparable2_id" => "12", "value" => "0.25"},
      "2" => {"comparable1_id" => "11", "comparable2_id" => "13", "value" => "4"}
    }
  }

  context "ordered pairs" do
    
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

  context "unordered pairs" do

    subject { AHPComparisonCalculator.new(unordered_comparisons, choices) }

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
end