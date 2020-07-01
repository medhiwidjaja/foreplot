require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:darcy) { create :darcy }
  let!(:article) { build :article }

  subject { article }

  context "when input is correct" do
    it { is_expected.to respond_to(:title) } 
    it { is_expected.to respond_to(:user) } 
    it { is_expected.to be_valid }
  end

  context "when input is incorrect" do
    before { article.title = nil }
    it { is_expected.not_to be_valid }
  end

  describe "when user is not present" do
    before { article.user = nil }
    it { is_expected.not_to be_valid }
  end

  describe "creation of article goal" do
    it "creates goal when created for the first time" do
      expect { article.save }.to change { article.criteria.count }.by(1)
    end

    it "checks for article goal everytime it's saved" do
      article.save
      article.criteria.destroy_all
      expect { article.save }.to change { article.criteria.count }.by(1)
    end
  end

  context "when the owner is changed" do
    before { article.user = darcy }
    it "belongs to the new owner" do
      expect(article.user_id).to be(darcy.id)
    end
  end

  describe "associations" do
    it { expect(described_class.reflect_on_association(:alternatives).macro).to eq(:has_many) }
    it { expect(described_class.reflect_on_association(:criteria).macro).to eq(:has_many) }
    it { expect(described_class.reflect_on_association(:members).macro).to eq(:has_many) }
    it { expect(described_class.reflect_on_association(:user).macro).to eq(:belongs_to) }
  end

end
