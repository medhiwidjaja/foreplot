require 'rails_helper'

RSpec.describe Criterion, type: :model do
  let!(:article) { create :article }
  let(:root) { article.criteria.root }
  let(:criterion) { build :criterion, parent: root }

  subject { root }

  context "familial relationships" do
    before(:each) {
      3.times { subject.children << build(:criterion, article: article) }
    }

    it "has children" do
      expect(root.children.count).to eq(3)
    end
    it "has a parent" do
      expect(root.children.first.parent).to eq(root)
    end
    it "responds to root?" do
      expect(root.root?).to be(true)
    end
  end

  describe "validations" do
    it "must have a title" do
      root.title = nil
      expect(root).to be_invalid
    end

    it "rejects without parent_id" do
      orphan = build(:criterion, article: article, parent_id: nil)
      expect(orphan).to be_invalid
    end
  end

  describe "creating new criterion assigns position" do
    context "for the first item in the Article" do
      it "assigns position no 1" do
        criterion.save
        expect( criterion.position ).to eq 1
      end
    end

    context "when there are other criterions in the article" do
      before {
        create :criterion, parent: root
        create :criterion, parent: root
      }
      it "assigns the next position number" do
        criterion.save
        expect( criterion.position ).to eq 3
      end
    end
  end

  describe "changing position number" do
    before {
      criterion.save
      appraisal = create :appraisal, criterion: root, appraisal_method: 'DirectComparison'
      @comparison = create :direct_comparison, comparable: criterion, appraisal: appraisal, position: 1
    }

    it "syncronize the position number in related ahp_comparisons" do
      criterion.position = 2
      expect { criterion.save }.to change { @comparison.reload.position }.from(1).to(2)
    end
  end

  describe "destroy" do
    it "should prevent deletion of root criterion" do
      expect { root.destroy }.to_not change(Criterion, :count)
    end
  end

  describe "associations" do
    it { expect(described_class.reflect_on_association(:children).macro).to eq(:has_many) }
    it { expect(described_class.reflect_on_association(:parent).macro).to eq(:belongs_to) }
    it { expect(described_class.reflect_on_association(:article).macro).to eq(:belongs_to) }
    it { expect(described_class.reflect_on_association(:comparisons).macro).to eq(:has_many) }
    it { expect(described_class.reflect_on_association(:appraisals).macro).to eq(:has_many) }
  end

end
