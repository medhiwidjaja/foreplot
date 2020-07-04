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

  describe "associations" do
    it { expect(described_class.reflect_on_association(:properties).macro).to eq(:has_many) }
    it { expect(described_class.reflect_on_association(:rankings).macro).to eq(:has_many) }
    it { expect(described_class.reflect_on_association(:article).macro).to eq(:belongs_to) }
    it { expect(described_class.reflect_on_association(:comparisons).macro).to eq(:has_many) }
  end
end
