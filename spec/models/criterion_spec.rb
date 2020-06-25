require 'rails_helper'

RSpec.describe Criterion, type: :model do
  let(:criterion) { create :criterion }

  subject { criterion }

  before(:each) {
    3.times { create :criterion, parent_id: criterion.id }
    @tree = criterion.to_tree
  }

  context "associations" do
    it "has children" do
      expect(criterion.children.count).to eq(3)
    end
    it "has a parent" do
      expect(criterion.children.first.parent).to eq(criterion)
    end
    it "responds to root?" do
      expect(criterion.root?).to be(true)
    end
  end

  context "converting into tree" do
    it "has a root" do
      expect(@tree.root.name).to match /Criterion/
    end
    it "has 3 children" do
      expect(@tree.children.count).to eq(3)
    end
    
  end 
end
