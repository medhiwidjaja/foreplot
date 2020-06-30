require 'rails_helper'

RSpec.describe Ranking, type: :model do

  describe "associations" do
    it { expect(described_class.reflect_on_association(:alternative).macro).to eq(:belongs_to) }
    it { expect(described_class.reflect_on_association(:user).macro).to eq(:belongs_to) }
    it { expect(described_class.reflect_on_association(:vote).macro).to eq(:belongs_to) }
    it { expect(described_class.reflect_on_association(:article).macro).to eq(:belongs_to) }
  end
end
