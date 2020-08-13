require 'rails_helper'

RSpec.describe MagiqComparisonsForm do
  let!(:article) { create :article }
  let(:criterion) { article.criteria.root }
  let(:member)    { create :member }
  let(:appraisal) { build :appraisal, member_id: member.id, criterion_id: criterion.id, appraisal_method:'MagiqComparison'}
  let(:c1) { create :criterion, article:article, parent:criterion }
  let(:c2) { create :criterion, article:article, parent:criterion }
  let(:c3) { create :criterion, article:article, parent:criterion }
  let(:params)    {
    {:criterion_id=>criterion.id, :member_id=>member.id, :appraisal_method=>"MagiqComparison", 
      :magiq_comparisons_attributes=>{
        "2"=>{"score"=>"0.611111111111111", "score_n"=>"0.611111111111111", "rank"=>"1", "rank_method"=>"rank_order_centroid", "comparable_id"=>c3.id, "comparable_type"=>"Criterion", "title"=>c3.title}, 
        "1"=>{"score"=>"0.27777777777777773", "score_n"=>"0.27777777777777773", "rank"=>"2", "rank_method"=>"rank_order_centroid", "comparable_id"=>c2.id, "comparable_type"=>"Criterion", "title"=>c2.title}, 
        "0"=>{"score"=>"0.1111111111111111", "score_n"=>"0.1111111111111111", "rank"=>"3", "rank_method"=>"rank_order_centroid", "comparable_id"=>c1.id, "comparable_type"=>"Criterion", "title"=>c1.title}
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
  end

  describe "editing comparisons" do
    let(:persisted_appraisal) { create :appraisal, member_id: member.id, criterion_id: criterion.id, appraisal_method:'MagiqComparison', is_complete:true }
    let(:dc1) { MagiqComparison.new(rank: 1, rank_method: 'rank_order_centroid', score: 1, comparable_id:c1.id, comparable_type: 'Criterion') }
    let(:dc2) { MagiqComparison.new(rank: 2, rank_method: 'rank_order_centroid', score: 2, comparable_id:c2.id, comparable_type: 'Criterion') }
    let(:dc3) { MagiqComparison.new(rank: 3, rank_method: 'rank_order_centroid', score: 4, comparable_id:c3.id, comparable_type: 'Criterion') }
    let(:persisted_comparisons) { [ dc1, dc2, dc3 ] }

    before(:each) do
      persisted_appraisal.magiq_comparisons << persisted_comparisons
      @new_params = {:criterion_id=>criterion.id, :member_id=>member.id, :appraisal_method=>"MagiqComparison", 
        :magiq_comparisons_attributes=>{
          "2"=>{"score"=>"0.611111111111111", "score_n"=>"0.611111111111111", "rank"=>"1", "rank_method"=>"rank_order_centroid", "id"=>persisted_appraisal.magiq_comparisons.first.id}, 
          "1"=>{"score"=>"0.27777777777777773", "score_n"=>"0.27777777777777773", "rank"=>"2", "rank_method"=>"rank_order_centroid", "id"=>persisted_appraisal.magiq_comparisons.second.id}, 
          "0"=>{"score"=>"0.1111111111111111", "score_n"=>"0.1111111111111111", "rank"=>"3", "rank_method"=>"rank_order_centroid", "id"=>persisted_appraisal.magiq_comparisons.third.id}
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
      expect(comparisons.order(:score_n).map{|x| "%0.2f" % x.score}).to eq(["0.11", "0.28", "0.61"])
    end

  end
end