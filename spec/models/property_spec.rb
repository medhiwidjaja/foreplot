require 'rails_helper'

RSpec.describe Property, type: :model do

  describe "associations" do
    it { expect(described_class.reflect_on_association(:alternative).macro).to eq(:belongs_to) }
  end
end
