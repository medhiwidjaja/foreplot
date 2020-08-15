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

    describe "rank numbers should be sequential, starting from 1" do
      context "rank numbers are sequential" do
        before {
          allow_any_instance_of(MagiqComparison).to receive(:valid?).and_return(:true)
          appraisal.magiq_comparisons << [
            build(:magiq_comparison, rank: 1),
            build(:magiq_comparison, rank: 2),
            build(:magiq_comparison, rank: 2),
            build(:magiq_comparison, rank: 3),
            build(:magiq_comparison, rank: 3)
          ]
        }
        it { is_expected.to be_valid }
      end

      context "rank numbers are intermittent" do
        before {
          allow_any_instance_of(MagiqComparison).to receive(:valid?).and_return(:true)
          appraisal.magiq_comparisons << [
            build(:magiq_comparison, rank: 3),
            build(:magiq_comparison, rank: 3),
            build(:magiq_comparison, rank: 3),
            build(:magiq_comparison, rank: 5),
            build(:magiq_comparison, rank: 5)
          ]
        }
        it { is_expected.to be_invalid }

        it "sets correct error messages" do
          appraisal.valid?
          expect(appraisal.errors.messages).to eq({:base=>["Slots 1, 2, 4 can't be empty"]})
        end
      end
    end
  end

  describe "associations" do
    it { expect(described_class.reflect_on_association(:criterion).macro).to eq(:belongs_to) }
    it { expect(described_class.reflect_on_association(:direct_comparisons).macro).to eq(:has_many) }
    it { expect(described_class.reflect_on_association(:magiq_comparisons).macro).to eq(:has_many) }
    it { expect(described_class.reflect_on_association(:ahp_comparisons).macro).to eq(:has_many) }
  end
end
