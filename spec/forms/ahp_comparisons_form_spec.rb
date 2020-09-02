require 'rails_helper'

RSpec.describe AHPComparisonsForm do
  let!(:article) { create :article }
  let(:criterion) { article.criteria.root }
  let(:member)    { create :member }
  let(:appraisal) { build :appraisal, member_id: member.id, criterion_id: criterion.id, appraisal_method:'AHPComparison'}
  let(:c1) { create :criterion, article:article, parent:criterion }
  let(:c2) { create :criterion, article:article, parent:criterion }
  let(:c3) { create :criterion, article:article, parent:criterion }
  let(:params)    {
    {:criterion_id=>criterion.id, :member_id=>member.id, :appraisal_method=>"AHPComparison"
      :ahp_comparisons_attributes=>{
        "0"=>{"comparable_id"=>c1.id, "comparable_type"=>"Criterion", "title"=>c1.title}, 
        "1"=>{"comparable_id"=>c2.id, "comparable_type"=>"Criterion", "title"=>c2.title}, 
        "2"=>{"comparable_id"=>c3.id, "comparable_type"=>"Criterion", "title"=>c3.title}
      },
      :pairwise_comparisons_attributes=>{
        "0"=>{"comparable1_id"=>c1.id, "comparable1_type"=>"Criterion", "comparable2_id"=>c2.id, "comparable2_type"=>"Criterion", "value"=>-4}, 
        "1"=>{"comparable1_id"=>c1.id, "comparable1_type"=>"Criterion", "comparable2_id"=>c3.id, "comparable2_type"=>"Criterion", "value"=>4}, 
        "2"=>{"comparable1_id"=>c2.id, "comparable1_type"=>"Criterion", "comparable2_id"=>c3.id, "comparable2_type"=>"Criterion", "value"=>9}
      }
    }
  }

  describe 'Assigns' do
    it 'assigns variables' do 
      form = described_class.new(appraisal, params)
      expect(form.member_id).to eq(member.id)
      expect(form.criterion_id).to eq(criterion.id)
      expect(form.ahp_comparisons_attributes).to eq(params[:ahp_comparisons_attributes])
      expect(form.pairwise_comparisons_attributes).to eq(params[:pairwise_comparisons_attributes])
    end
  end 

  describe ".submit" do

    it "saves new appraisal" do
      form = described_class.new appraisal, params
      expect{ form.submit }.to change(Appraisal, :count).by(1)
      expect(appraisal).to be_valid
      expect(form).to be_valid
    end

    it "saves the comparison results" do
      form = described_class.new appraisal, params
      expect{ form.submit }.to change(AHPComparison, :count).by(3)
    end

    it "saves the pairwise comparisons" do
      form = described_class.new appraisal, params
      expect{ form.submit }.to change(PairwiseComparison, :count).by(3)
    end

    let(:expected_scores) {
      ["0.72", "0.22", "0.07"]
    }
    it "stores correct comparison results" do
      form = described_class.new appraisal, params
      form.submit
      expect(appraisal.ahp_comparisons.order(:id).map{|x| "%0.2f" % x.score_n}).to eq(expected_scores)
    end

  end

  describe "editing comparisons" do
    let(:persisted_appraisal) { create :appraisal, member_id: member.id, criterion_id: criterion.id, 
                                appraisal_method:'AHPComparison', is_complete:true }
    let(:persisted_ahp_comparisons) { [ 
      build(:ahp_comparison, rank: 1, score: 0.3, comparable_id:c1.id, comparable_type: 'Criterion'), 
      build(:ahp_comparison, rank: 2, score: 0.3, comparable_id:c2.id, comparable_type: 'Criterion'), 
      build(:ahp_comparison, rank: 3, score: 0.3, comparable_id:c3.id, comparable_type: 'Criterion')
    ]}
    let(:persisted_pairwise_comparisons) { [
      build(:pairwise_comparison, comparable1_id: c1.id, comparable2_id: c2.id, value: 1),
      build(:pairwise_comparison, comparable1_id: c1.id, comparable2_id: c3.id, value: 1),
      build(:pairwise_comparison, comparable1_id: c2.id, comparable2_id: c3.id, value: 1)
    ]}

    before(:each) do
      persisted_appraisal.ahp_comparisons << persisted_ahp_comparisons
      persisted_appraisal.pairwise_comparisons << persisted_pairwise_comparisons
      @new_params = {:criterion_id=>criterion.id, :member_id=>member.id, :appraisal_method=>"AHPComparison",
        :ahp_comparisons_attributes => {
          "0"=>{"comparable_id"=>c1.id, "comparable_type"=>"Criterion", "title"=>c1.title, "id"=>persisted_appraisal.ahp_comparisons.first.id}, 
          "1"=>{"comparable_id"=>c2.id, "comparable_type"=>"Criterion", "title"=>c2.title, "id"=>persisted_appraisal.ahp_comparisons.second.id}, 
          "2"=>{"comparable_id"=>c3.id, "comparable_type"=>"Criterion", "title"=>c3.title, "id"=>persisted_appraisal.ahp_comparisons.last.id}
        },
        :pairwise_comparisons_attributes => {
          "0"=>{"comparable1_id" => "#{c1.id}", "comparable2_id" => "#{c2.id}", "value"=>"-4", "id"=>persisted_appraisal.pairwise_comparisons.first.id }, 
          "1"=>{"comparable1_id" => "#{c1.id}", "comparable2_id" => "#{c3.id}", "value"=>"4", "id"=>persisted_appraisal.pairwise_comparisons.second.id }, 
          "2"=>{"comparable1_id" => "#{c2.id}", "comparable2_id" => "#{c3.id}", "value"=>"9", "id"=>persisted_appraisal.pairwise_comparisons.last.id }
        }
      }
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
      comparisons = persisted_appraisal.ahp_comparisons.reload
      expect(comparisons.order(:comparable_id).map{|x| "%0.2f" % x.score}).to eq(["0.22", "0.72", "0.07"])
    end

  end
end