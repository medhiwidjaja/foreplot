require 'rails_helper'

RSpec.describe MagiqComparisonsForm do

  include_context "criteria context for comparisons" 

  let(:appraisal) { build :appraisal, member_id: member.id, criterion_id: criterion.id, appraisal_method:'MagiqComparison', rank_method: 'rank_order_centroid'}
  let(:params)    {
    {:criterion_id=>criterion.id, :member_id=>member.id, :appraisal_method=>"MagiqComparison", rank_method: 'rank_order_centroid', 
      :magiq_comparisons_attributes=>{
        "0"=>{"rank"=>"1", "comparable_id"=>c1.id, "comparable_type"=>"Criterion", "title"=>c1.title, "position"=>c1.position}, 
        "1"=>{"rank"=>"2", "comparable_id"=>c2.id, "comparable_type"=>"Criterion", "title"=>c2.title, "position"=>c2.position}, 
        "2"=>{"rank"=>"3", "comparable_id"=>c3.id, "comparable_type"=>"Criterion", "title"=>c3.title, "position"=>c3.position}
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
      expect(appraisal.magiq_comparisons.order(:id).map{|x| "%0.2f" % x.score_n}).to eq(["0.61", "0.28", "0.11"])
    end

    it "set the is_complete flag in Appraisal" do
      form = described_class.new appraisal, params
      form.submit
      expect(appraisal.is_complete).to eq(true)
    end

  end

  describe "editing comparisons" do
    let(:persisted_appraisal) { create :appraisal, member_id: member.id, criterion_id: criterion.id, 
                                appraisal_method:'MagiqComparison', rank_method: 'rank_order_centroid', is_complete:true, comparable_type: 'Criterion' }
    let(:dc1) { MagiqComparison.new(rank: 1, comparable_id:c1.id, comparable_type: 'Criterion', "position"=>c1.position) }
    let(:dc2) { MagiqComparison.new(rank: 2, comparable_id:c2.id, comparable_type: 'Criterion', "position"=>c2.position) }
    let(:dc3) { MagiqComparison.new(rank: 3, comparable_id:c3.id, comparable_type: 'Criterion', "position"=>c3.position) }
    let(:persisted_comparisons) { [ dc1, dc2, dc3 ] }

    before(:each) do
      persisted_appraisal.magiq_comparisons << persisted_comparisons
      @new_params = {:criterion_id=>criterion.id, :member_id=>member.id, :appraisal_method=>"MagiqComparison", rank_method:'rank_sum',
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
      expect(comparisons.order(:id).map{|x| "%0.2f" % x.score}).to eq(["0.33", "0.17", "0.50"])
    end


    it "saves the specified rank method" do
      form = described_class.new persisted_appraisal, @new_params
      form.submit
      expect(persisted_appraisal.rank_method).to eq('rank_sum')
    end

  end
end