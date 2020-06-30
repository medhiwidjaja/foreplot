require 'rails_helper'

RSpec.describe Vote, type: :model do

  describe "associations" do
    it { expect(described_class.reflect_on_association(:rankings).macro).to eq(:has_many) }
    it { expect(described_class.reflect_on_association(:user).macro).to eq(:belongs_to) }
    it { expect(described_class.reflect_on_association(:article).macro).to eq(:belongs_to) }
  end

end
