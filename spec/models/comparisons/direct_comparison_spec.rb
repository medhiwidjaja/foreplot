require 'rails_helper'

RSpec.describe DirectComparison, type: :model do
  
  let (:root) { create :criterion, :with_appraisal, :with_3_children }
  let (:comparables ) { root.children }
  let (:valid_attributes) {
    { title: 'Title', value: 12.0, unit: 'pcs', score: 0.2, score_n: 0.2, appraisal: root.appraisals.first }
  }
  before {
    comparables.each { |c| 
      c.direct_comparisons << DirectComparison.create(valid_attributes) 
    }
    @comparison = comparables.first.direct_comparisons.first
  }

  subject {@comparison}

  describe "with valid data" do
    it "is valid" do
      expect(@comparison).to be_valid
    end

    it "holds reference to the criterion" do
      expect(@comparison.comparable).to eq(comparables.first)
      expect(@comparison.comparable_type).to eq('Criterion')
    end
  end

  describe "without a value" do
    it "is not valid" do
      @comparison.value = nil
      expect(@comparison.valid?).to eq(false)
    end
  end

  describe "associations" do
    it { expect(described_class.reflect_on_association(:comparable).macro).to eq(:belongs_to) }
  end
end