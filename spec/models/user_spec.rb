require 'rails_helper'

RSpec.describe User, type: :model do

  let!(:darcy) { create(:darcy) }

  subject { darcy }

  it { should respond_to(:name) } 
  it { should respond_to(:email) } 

  it { is_expected.to be_valid }

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

end


