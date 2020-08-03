require 'rails_helper'

RSpec.describe Appraisal, type: :model do
  let(:criterion) { create :criterion }
  let(:member)    { create :member }
  let(:appraisal) { create :appraisal, criterion: criterion, member: member }

  subject { appraisal }

  context "when input is correct" do
    it { is_expected.to respond_to(:appraisal_method) } 
    it { is_expected.to respond_to(:is_valid) } 
    it { is_expected.to be_valid }
  end

  context "invalid data" do
    describe "when member is missing" do
      before { appraisal.member = nil }
      it { is_expected.not_to be_valid }
    end
  end

  describe "associations" do
    it { expect(described_class.reflect_on_association(:criterion).macro).to eq(:belongs_to) }
    it { expect(described_class.reflect_on_association(:comparisons).macro).to eq(:has_many) }
    it { expect(described_class.reflect_on_association(:pairwise_comparisons).macro).to eq(:has_many) }
  end
end
