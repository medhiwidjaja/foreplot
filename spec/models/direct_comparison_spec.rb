require 'rails_helper'

RSpec.describe DirectComparison, type: :model do
  
  let (:criterion) { create :criterion }
  let (:comparables ) { 3.times { build :criterion, parent_id: criterion.id } }

  describe "associations" do
    it { expect(described_class.reflect_on_association(:criterion).macro).to eq(:belongs_to) }
    it { expect(described_class.reflect_on_association(:comparable).macro).to eq(:belongs_to) }
  end
end