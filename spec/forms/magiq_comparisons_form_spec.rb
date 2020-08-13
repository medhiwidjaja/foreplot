require 'rails_helper'

RSpec.describe MagiqComparisonsForm do
  let!(:article) { create :article }
  let(:criterion) { article.criteria.root }
  let(:member)    { create :member }
  let(:appraisal) { build :appraisal, member_id: member.id, criterion_id: criterion.id, appraisal_method:'MagiqComparison', rank_method: 'rank_order_centroid'}
  let(:c1) { create :criterion, article:article, parent:criterion }
  let(:c2) { create :criterion, article:article, parent:criterion }
  let(:c3) { create :criterion, article:article, parent:criterion }
  let(:params)    {
    {:criterion_id=>criterion.id, :member_id=>member.id, :appraisal_method=>"MagiqComparison", 
      :magiq_comparisons_attributes=>{
        "0"=>{"rank"=>"1", "comparable_id"=>c1.id, "comparable_type"=>"Criterion", "title"=>c1.title}, 
        "1"=>{"rank"=>"2", "comparable_id"=>c2.id, "comparable_type"=>"Criterion", "title"=>c2.title}, 
        "2"=>{"rank"=>"3", "comparable_id"=>c3.id, "comparable_type"=>"Criterion", "title"=>c3.title}
      }
    }
  }

  describe 'Assigns' do
    it 'assigns variables' do 
      form = described_class.new(appraisal, params)
      expect(form.member_id).to eq(member.id)
      expect(form.criterion_id).to eq(criterion.id)
      expect(form.magiq_comparisons_attributes).to eq(params[:magiq_comparisons_attributes])
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
      expect{ form.submit }.to change(MagiqComparison, :count).by(3)
    end

    it "stores correct comparison results" do
      form = described_class.new appraisal, params
      form.submit
      expect(appraisal.magiq_comparisons.order(:id).map{|x| "%0.2f" % x.score}).to eq(["0.61", "0.28", "0.11"])
    end
  end

  describe "editing comparisons" do
    let(:persisted_appraisal) { create :appraisal, member_id: member.id, criterion_id: criterion.id, 
                                appraisal_method:'MagiqComparison', rank_method: 'rank_order_centroid', is_complete:true }
    let(:dc1) { MagiqComparison.new(rank: 1, comparable_id:c1.id, comparable_type: 'Criterion') }
    let(:dc2) { MagiqComparison.new(rank: 2, comparable_id:c2.id, comparable_type: 'Criterion') }
    let(:dc3) { MagiqComparison.new(rank: 3, comparable_id:c3.id, comparable_type: 'Criterion') }
    let(:persisted_comparisons) { [ dc1, dc2, dc3 ] }

    before(:each) do
      persisted_appraisal.magiq_comparisons << persisted_comparisons
      @new_params = {:criterion_id=>criterion.id, :member_id=>member.id, :appraisal_method=>"MagiqComparison", 
        :magiq_comparisons_attributes=>{
          "0"=>{"rank"=>"2", "id"=>persisted_appraisal.magiq_comparisons.first.id}, 
          "1"=>{"rank"=>"3", "id"=>persisted_appraisal.magiq_comparisons.second.id}, 
          "2"=>{"rank"=>"1", "id"=>persisted_appraisal.magiq_comparisons.third.id}
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
      comparisons = persisted_appraisal.magiq_comparisons.reload
      expect(comparisons.order(:id).map{|x| "%0.2f" % x.score}).to eq(["0.28", "0.11", "0.61"])
    end

  end
end