require 'rails_helper'

RSpec.describe DirectComparisonCalculatorService, type: :service do
  let(:direct_comparisons) {
    [ build(:comparison, id:1, value:1.0),
      build(:comparison, id:2, value:2.0),
      build(:comparison, id:3, value:4.0)]
  }

  let(:expected_result) { 
    [{:id=>3, :rank=>1}, {:id=>2, :rank=>2}, {:id=>1, :rank=>3}]
  }

  subject { DirectComparisonCalculatorService.new }

  describe 'call' do
    it 'returns modified hash' do
      expect(subject.call(direct_comparisons).map {|c| c.except(:value, :score, :score_n)}).to eq expected_result
    end
  end
end