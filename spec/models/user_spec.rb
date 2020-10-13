require 'rails_helper'

RSpec.describe User, type: :model do

  let!(:darcy) { create(:darcy) }

  subject { darcy }

  context "when input is correct" do
    it { is_expected.to respond_to(:name) } 
    it { is_expected.to respond_to(:email) } 
    it { is_expected.to be_valid }
  end

  describe "when name is not present" do
    before { darcy.name = " " }
    it { is_expected.not_to be_valid }
  end

  describe "when email is not present" do
    before { darcy.email = " " }
    it { is_expected.not_to be_valid }
  end

  describe "when email is a duplicate" do
    let(:another_darcy) { build(:darcy) }
    it "should be invalid" do
      expect(another_darcy).not_to be_valid
    end
  end

  describe "when password is too short" do
    before { darcy.password = "12345" }
    it { is_expected.not_to be_valid }
  end

  describe "when email is not properly formatted" do
    before { darcy.email = "what is this?" }
    it { is_expected.not_to be_valid }
  end

  describe "when role is not present" do
    before { darcy.role = " " }
    it { is_expected.not_to be_valid }
  end

  describe "when account is not present" do
    before { darcy.account = " " }
    it { is_expected.not_to be_valid }
  end

  describe "associations" do
    it { expect(described_class.reflect_on_association(:articles).macro).to eq(:has_many) }
    it { expect(described_class.reflect_on_association(:rankings).macro).to eq(:has_many) }
    it { expect(described_class.reflect_on_association(:memberships).macro).to eq(:has_many) }
  end

  context "with friends" do
    let(:bingley) { create :bingley }

    describe "following" do
      it "allows user to follow other user" do
        expect(darcy.following? bingley).to eq false 
        expect { darcy.follow bingley }.to change { darcy.follow_count }.by(1)
        expect(darcy.following? bingley).to eq true 
      end
    end

    describe "followers" do
      it "allows user to be followed by other user" do
        expect(darcy.followers).to  eq [] 
        expect { bingley.follow darcy }.to change { bingley.follow_count }.by(1)
        expect(darcy.followers).to include(bingley) 
      end
    end
  end
end


