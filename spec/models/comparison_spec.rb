require 'rails_helper'

RSpec.describe DirectComparison, type: :model do
  let!(:article) { create :article }
  let(:criterion) { article.criteria.root }
  let(:appraisal) { create :appraisal, criterion_id: criterion.id, appraisal_method:'DirectComparison'}
  let!(:direct_comparison) { create :direct_comparison, appraisal_id: appraisal.id, value: 100,
                             comparable_id: criterion.id, comparable_type: 'Criterion' }

  describe "uniqueness validation" do
    it "accepts comparison for different criterion" do
      new_criterion = create :criterion, article: article, parent: criterion
      new_comparison = build :direct_comparison, appraisal_id: appraisal.id, value: 100, comparable_id: new_criterion.id, comparable_type: 'Criterion'
      expect(new_comparison).to be_valid
    end

    it "rejects comparison for same criterion" do
      same_comparison = build :direct_comparison, appraisal_id: appraisal.id, value: 100, comparable_id: criterion.id, comparable_type: 'Criterion'
      expect(same_comparison).to be_invalid
    end

    it "accepts comparison for different appraisal" do
      member = build :member
      different_appraisal = create :appraisal, criterion: criterion, member: member, appraisal_method:'DirectComparison'
      new_comparison = build :direct_comparison, appraisal_id: different_appraisal.id, value: 100, comparable_id: criterion.id, comparable_type: 'Criterion'
      expect(new_comparison).to be_valid
    end
  end

  describe "associations" do
    it { expect(described_class.reflect_on_association(:comparable).macro).to eq(:belongs_to) }
    it { expect(described_class.reflect_on_association(:appraisal).macro).to eq(:belongs_to) }
  end
end
