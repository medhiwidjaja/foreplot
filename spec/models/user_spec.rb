require 'rails_helper'

RSpec.describe User, type: :model do

  let(:darcy) { create(:darcy) }

  it { should respond_to(:name) } 
  it { should respond_to(:email) } 

  it { should be_valid }

  describe "when name is not present" do
    before { darcy.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { darcy.email = " " }
    it { should_not be_valid }
  end

  describe "when email is a duplicate" do
    let(:another_darcy) { build(:darcy) }
    it "should be invalid" do
      assert another_user.invalid?
    end
  end

end


