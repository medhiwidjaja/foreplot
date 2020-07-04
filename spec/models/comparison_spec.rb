require 'rails_helper'

RSpec.describe DirectComparison, type: :model do
  describe "association with owner model" do
    it { expect(described_class.reflect_on_association(:comparable).macro).to eq(:belongs_to) }
  end
end
