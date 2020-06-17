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

  describe "when user is not present" do
    before { article.user = nil }
    it { is_expected.not_to be_valid }
  end

  context "when the owner is changed" do
    before { article.user = darcy }
    it "belongs to the new owner" do
      expect(article.user_id).to be(darcy.id)
    end
  end

end
