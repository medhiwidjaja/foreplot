require 'rails_helper'

RSpec.describe Alternative, type: :model do
  let(:darcy) { create :darcy }
  let!(:article) { create :article, user_id: darcy.id}
  let!(:alternative) { build :alternative, article: article}

  subject { alternative }

  context "when input is correct" do
    it "belongs to the right article" do
      expect(alternative.article_id).to be(article.id)
    end
    it { is_expected.to respond_to(:title) } 
    it { is_expected.to be_valid }
  end

  describe "when article is not present" do
    before { alternative.article = nil }
    it { is_expected.not_to be_valid }
  end

  describe "creating new alternative assigns position" do
    context "for the first item in the Article" do
      it "assigns position no 1" do
        alternative.save
        expect( alternative.position ).to eq 1
      end
    end

    context "when there are other alternatives in the article" do
      before {
        create :alternative, article: article
        create :alternative, article: article
      }
      it "assigns the next position number" do
        alternative.save
        expect( alternative.position ).to eq 3
      end
    end
  end

  describe "changing position number" do
    let(:root) { article.criteria.root }
    before {
      alternative.save
      appraisal = build :appraisal, criterion: root, appraisal_method: 'AHPComparison'
      @ahp      = create :magiq_comparison, comparable: alternative, appraisal: appraisal, position: 1
    }

    it "syncronize the position number in related comparisons" do
      alternative.position = 2
      expect { alternative.save }.to change { @ahp.reload.position }.from(1).to(2)
    end
  end

  describe "associations" do
    it { expect(described_class.reflect_on_association(:properties).macro).to eq(:has_many) }
    it { expect(described_class.reflect_on_association(:rankings).macro).to eq(:has_many) }
    it { expect(described_class.reflect_on_association(:article).macro).to eq(:belongs_to) }
    it { expect(described_class.reflect_on_association(:comparisons).macro).to eq(:has_many) }
  end
end
