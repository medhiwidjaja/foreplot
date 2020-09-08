require 'rails_helper'

RSpec.describe Criterion, type: :model do
  let!(:article) { create :article }
  let(:root) { article.criteria.root }

  subject { root }

  before(:each) {
    3.times { root.children << build(:criterion, article: article) }
  }

  context "familial relationships" do
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

  describe "associations" do
    it { expect(described_class.reflect_on_association(:children).macro).to eq(:has_many) }
    it { expect(described_class.reflect_on_association(:parent).macro).to eq(:belongs_to) }
    it { expect(described_class.reflect_on_association(:article).macro).to eq(:belongs_to) }
    it { expect(described_class.reflect_on_association(:comparisons).macro).to eq(:has_many) }
    it { expect(described_class.reflect_on_association(:appraisals).macro).to eq(:has_many) }
  end

end
