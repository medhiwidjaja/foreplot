require 'rails_helper'

RSpec.describe Appraisal, type: :model do
  let!(:article) { create :article }
  let(:criterion) { article.criteria.root }
  let(:member)    { create :member }
  let!(:appraisal) { create :appraisal, criterion: criterion, member: member, appraisal_method: 'DirectComparison' }

  subject { appraisal }

  context "when input is correct" do
    it { is_expected.to respond_to(:appraisal_method) } 
    it { is_expected.to respond_to(:is_valid) } 
    it { is_expected.to be_valid }
  end

  context "invalid data" do
    describe "when member is missing" do
      before { appraisal.member = nil }
      it { is_expected.not_to be_valid }
    end
  end

  describe "uniqueness validation" do
    it "rejects appraisal with same method by the same member" do
      other_appraisal = build :appraisal, criterion: criterion, member: member, appraisal_method: 'DirectComparison'
      expect(other_appraisal).to be_invalid
    end

    it "rejects appraisal with different method by the same member" do
      other_appraisal = build :appraisal, criterion: criterion, member: member, appraisal_method: 'MagiqComparison', rank_method: 'rank_sum'
      expect(other_appraisal).to be_invalid
    end
  end

  describe "validation for Magiq comparison" do
    let!(:appraisal) { create :appraisal, criterion: criterion, member: member, appraisal_method: 'MagiqComparison', rank_method: 'rank_order_centroid'}
    subject { appraisal }
    it { is_expected.to be_valid }
    it "is not valid without rank method" do
      appraisal.rank_method = nil
      is_expected.to be_invalid
    end
  end

  describe "associations" do
    it { expect(described_class.reflect_on_association(:criterion).macro).to eq(:belongs_to) }
    it { expect(described_class.reflect_on_association(:direct_comparisons).macro).to eq(:has_many) }
    it { expect(described_class.reflect_on_association(:magiq_comparisons).macro).to eq(:has_many) }
    it { expect(described_class.reflect_on_association(:ahp_comparisons).macro).to eq(:has_many) }
  end
end
