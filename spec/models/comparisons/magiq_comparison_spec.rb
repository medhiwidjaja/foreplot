require 'rails_helper'

RSpec.describe MagiqComparison, type: :model do
  let!(:article) { create :article }
  let(:root) { article.criteria.root }
  let(:appraisal) { create :appraisal, criterion: root }
  before {
    3.times { root.children << build(:criterion, article: article) }
  }
  let (:comparables ) { root.children }
  let (:valid_attributes) {
    { title: 'Title', rank: 1.0, score: 0.2, score_n: 0.2, appraisal: appraisal }
  }
  before {
    comparables.each { |c| c.magiq_comparisons << MagiqComparison.create(valid_attributes) }
    @comparison = comparables.first.magiq_comparisons.first
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

  describe "without rank no" do
    it "is not valid" do
      @comparison.rank = nil
      expect(@comparison.valid?).to eq(false)
    end
  end


  describe "associations" do
    it { expect(described_class.reflect_on_association(:comparable).macro).to eq(:belongs_to) }
  end
end