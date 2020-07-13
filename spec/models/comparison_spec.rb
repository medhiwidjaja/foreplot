require 'rails_helper'

RSpec.describe DirectComparison, type: :model do
  describe "associations" do
    it { expect(described_class.reflect_on_association(:comparable).macro).to eq(:belongs_to) }
    it { expect(described_class.reflect_on_association(:assay).macro).to eq(:belongs_to) }
  end
end
