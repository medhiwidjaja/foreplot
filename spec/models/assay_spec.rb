require 'rails_helper'

RSpec.describe Assay, type: :model do
  let(:criterion) { create :criterion }
  let(:member)    { create :member }
  let(:assay) { create :assay, criterion: criterion, member: member }

  subject { assay }

  context "when input is correct" do
    it { is_expected.to respond_to(:assay_method) } 
    it { is_expected.to respond_to(:is_valid) } 
    it { is_expected.to be_valid }
  end

  describe "associations" do
    it { expect(described_class.reflect_on_association(:criterion).macro).to eq(:belongs_to) }
    it { expect(described_class.reflect_on_association(:comparisons).macro).to eq(:has_many) }
  end
end
