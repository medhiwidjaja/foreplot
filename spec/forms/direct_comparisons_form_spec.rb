require 'rails_helper'

RSpec.describe DirectComparisonsForm do
  let!(:article) { create :article }
  let(:criterion) { article.criteria.root }
  let(:member)    { create :member }
  let(:appraisal) { build :appraisal, member_id: member.id, criterion_id: criterion.id, appraisal_method:'DirectComparison'}
  let(:c1) { create :criterion, article:article, parent:criterion }
  let(:c2) { create :criterion, article:article, parent:criterion }
  let(:c3) { create :criterion, article:article, parent:criterion }
  let(:params)    {
    {:criterion_id=>criterion.id, :member_id=>member.id, :appraisal_method=>"DirectComparison", 
      :direct_comparisons_attributes=>{
        "2"=>{"value"=>"5", "score"=>"0.5", "score_n"=>"0.5", "rank"=>"1", "comparable_id"=>c3.id, "comparable_type"=>"Criterion", "title"=>c3.title}, 
        "1"=>{"value"=>"4", "score"=>"0.4", "score_n"=>"0.4", "rank"=>"2", "comparable_id"=>c2.id, "comparable_type"=>"Criterion", "title"=>c2.title}, 
        "0"=>{"value"=>"1", "score"=>"0.1", "score_n"=>"0.1", "rank"=>"3", "comparable_id"=>c1.id, "comparable_type"=>"Criterion", "title"=>c1.title}
      }
    }
  }

  describe 'Assigns' do
    it 'assigns variables' do 
      form = described_class.new(appraisal, params)
      expect(form.member_id).to eq(member.id)
      expect(form.criterion_id).to eq(criterion.id)
      expect(form.direct_comparisons_attributes).to eq(params[:direct_comparisons_attributes])
    end
  end 

  describe ".submit" do

    it "saves new appraisal" do
      allow_any_instance_of(DirectComparisonsForm).to receive(:appraisal_method).and_return(params)
      form = described_class.new appraisal, params
      #expect{ form.submit }.to change(Appraisal, :count).by(1)
      expect(appraisal).to be_valid
      expect(form).to be_valid
    end
  end

  describe "editing comparisons" do
    let(:persisted_appraisal) { create :appraisal, member_id: member.id, criterion_id: criterion.id, appraisal_method:'DirectComparison', is_complete:true }
    let(:dc1) { DirectComparison.new(value: 100, rank: 3, score: 1, comparable_id:c1.id, comparable_type: 'Criterion') }
    let(:dc2) { DirectComparison.new(value: 200, rank: 2, score: 2, comparable_id:c2.id, comparable_type: 'Criterion') }
    let(:dc3) { DirectComparison.new(value: 400, rank: 1, score: 4, comparable_id:c3.id, comparable_type: 'Criterion') }
    let(:persisted_comparisons) { [ dc1, dc2, dc3 ] }

    before(:each) do
      persisted_appraisal.direct_comparisons << persisted_comparisons
      @new_params = {:criterion_id=>criterion.id, :member_id=>member.id, :appraisal_method=>"DirectComparison", 
        :direct_comparisons_attributes=>{
          "2"=>{"value"=>"5", "score"=>"0.5", "score_n"=>"0.5", "rank"=>"1", "id"=>persisted_appraisal.direct_comparisons.first.id}, 
          "1"=>{"value"=>"4", "score"=>"0.4", "score_n"=>"0.4", "rank"=>"2", "id"=>persisted_appraisal.direct_comparisons.second.id}, 
          "0"=>{"value"=>"1", "score"=>"0.1", "score_n"=>"0.1", "rank"=>"3", "id"=>persisted_appraisal.direct_comparisons.third.id}
        }
      }
      allow_any_instance_of(DirectComparisonsForm).to receive(:appraisal_method).and_return(@new_params)
    end

    it "updates persisted appraisal as well" do
      expect(persisted_appraisal.persisted?).to eq(true)
      form = described_class.new persisted_appraisal, @new_params
      expect{ form.submit }.to change(Appraisal, :count).by(0)
      expect(persisted_appraisal.is_complete).to eq(true)
    end

    it "updates comparisons of the persisted appraisal" do
      form = described_class.new persisted_appraisal, @new_params
      form.submit
      comparisons = persisted_appraisal.direct_comparisons.reload
      expect(comparisons.order(:score_n).map(&:score_n)).to eq([0.1, 0.4, 0.5])
      expect(comparisons.order(:value).map(&:value)).to eq([1.0, 4.0, 5.0])
    end

  end
end