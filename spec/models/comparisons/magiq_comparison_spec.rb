require 'rails_helper'

RSpec.describe MagiqComparison, type: :model do
  
  let (:criterion) { create :criterion, :with_3_children }
  let (:comparables ) { criterion.children }
  let (:valid_attributes) {
    { title: 'Title', rank_no: 1.0, rank_method: 'rank_order_centroid', score: 0.2, score_n: 0.2 }
  }
  before {
    comparables.each { |c| c.magiq_comparisons << MagiqComparison.create(valid_attributes) }
    @comparison = comparables.first.magiq_comparisons.first
  }

  subject {@comparison}

  describe "with valid data" do
    it "is valid" do
      expect(@comparison.valid?).to eq(true)
    end

    it "holds reference to the criterion" do
      expect(@comparison.comparable).to eq(comparables.first)
      expect(@comparison.comparable_type).to eq('Criterion')
    end
  end

  describe "without rank no" do
    it "is not valid" do
      @comparison.rank_no = nil
      expect(@comparison.valid?).to eq(false)
    end
  end

  describe "without rank method" do
    it "is not valid" do
      @comparison.rank_method = nil
      expect(@comparison.valid?).to eq(false)
    end
  end


  describe "associations" do
    it { expect(described_class.reflect_on_association(:comparable).macro).to eq(:belongs_to) }
  end
end