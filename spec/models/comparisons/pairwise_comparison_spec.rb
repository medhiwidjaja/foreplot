require 'rails_helper'

RSpec.describe PairwiseComparison, type: :model do

  describe "associations" do
    it { expect(described_class.reflect_on_association(:ahp_comparison).macro).to eq(:belongs_to) }
  end
end
