require 'rails_helper'

RSpec.describe "DirectComparisons", type: :request do
  
  include_context "criteria context for comparisons"

  let(:appraisal) { build :appraisal, member_id: member.id, criterion_id: root.id, appraisal_method:'DirectComparison'}

  let(:appraisal_attributes) {
    {:criterion_id=>root.id, :member_id=>member.id, :appraisal_method=>"DirectComparison", 
      :direct_comparisons_attributes=>{
        "2"=>{"value"=>"5", "score"=>"0.5", "score_n"=>"0.5", "rank"=>"1", "comparable_id"=>c3.id, "comparable_type"=>"Criterion", "title"=>c3.title, "position"=>c3.position}, 
        "1"=>{"value"=>"4", "score"=>"0.4", "score_n"=>"0.4", "rank"=>"2", "comparable_id"=>c2.id, "comparable_type"=>"Criterion", "title"=>c2.title, "position"=>c2.position}, 
        "0"=>{"value"=>"1", "score"=>"0.1", "score_n"=>"0.1", "rank"=>"3", "comparable_id"=>c1.id, "comparable_type"=>"Criterion", "title"=>c1.title, "position"=>c1.position}
      }
    }
  }
  let(:invalid_attributes) {
    { title: '' }
  }

  let(:alt_params)    {
    {:criterion_id=>c1.id, :member_id=>member.id, :appraisal_method=>"DirectComparison",
      :direct_comparisons_attributes=>{
        "2"=>{"value"=>"5", "score"=>"0.5", "score_n"=>"0.5", "rank"=>"1", "comparable_id"=>alt3.id, "comparable_type"=>"Alternative", "title"=>alt3.title, "position"=>alt3.position}, 
        "1"=>{"value"=>"4", "score"=>"0.4", "score_n"=>"0.4", "rank"=>"2", "comparable_id"=>alt2.id, "comparable_type"=>"Alternative", "title"=>alt2.title, "position"=>alt2.position}, 
        "0"=>{"value"=>"1", "score"=>"0.1", "score_n"=>"0.1", "rank"=>"3", "comparable_id"=>alt1.id, "comparable_type"=>"Alternative", "title"=>alt1.title, "position"=>alt1.position}
      }
    }
  }

  context "comparing sub-criteria" do
    before(:each) {
      sign_in bingley
      2.times { create(:criterion, parent_id: root.id) }
    }

    describe "GET #new" do
      it "returns a success response" do
        get criterion_new_direct_comparisons_path(root)
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      it "creates a new appraisal" do
        expect {
          post criterion_direct_comparisons_path(root), params: {direct_comparisons_form: appraisal_attributes}
        }.to change(Appraisal, :count).by(1)
      end

      it "should save related direct comparisons" do
        expect {
          post criterion_direct_comparisons_path(root), params: {direct_comparisons_form: appraisal_attributes}
        }.to change(DirectComparison, :count).by(3)
      end
    end

    describe "PATCH #update" do
      let(:persisted_appraisal) { create :appraisal, member_id: member.id, criterion_id: root.id, appraisal_method:'DirectComparison', is_complete:true, comparable_type: 'Criterion' }
      let(:dc1) { DirectComparison.new(value: 100, rank: 3, score: 1, comparable_id:c1.id, comparable_type: 'Criterion', position:c1.position) }
      let(:dc2) { DirectComparison.new(value: 200, rank: 2, score: 2, comparable_id:c2.id, comparable_type: 'Criterion', position:c2.position) }
      let(:dc3) { DirectComparison.new(value: 400, rank: 1, score: 4, comparable_id:c3.id, comparable_type: 'Criterion', position:c3.position) }
      let(:persisted_comparisons) { [ dc1, dc2, dc3 ] }

      before(:each) do
        persisted_appraisal.direct_comparisons << persisted_comparisons
        @new_params = {:criterion_id=>root.id, :member_id=>member.id, :appraisal_method=>"DirectComparison", 
          :direct_comparisons_attributes=>{
            "2"=>{"value"=>"5", "score"=>"0.5", "score_n"=>"0.5", "rank"=>"1", "id"=>persisted_appraisal.direct_comparisons.first.id}, 
            "1"=>{"value"=>"4", "score"=>"0.4", "score_n"=>"0.4", "rank"=>"2", "id"=>persisted_appraisal.direct_comparisons.second.id}, 
            "0"=>{"value"=>"1", "score"=>"0.1", "score_n"=>"0.1", "rank"=>"3", "id"=>persisted_appraisal.direct_comparisons.third.id}
          }
        }
      end

      it "updates the comparison with new values" do
        persisted_appraisal = root.appraisals.first
        patch criterion_direct_comparisons_path(root), params: {direct_comparisons_form: @new_params}
        persisted_appraisal.reload
        comparisons = persisted_appraisal.direct_comparisons.reload
        expect(comparisons.order(:score_n).map(&:score_n)).to eq([0.1, 0.4, 0.5])
        expect(comparisons.order(:value).map(&:value)).to eq([1.0, 4.0, 5.0])
      end

      it "redirects Criteria comparison to criterion" do
        patch criterion_direct_comparisons_path(root), params: {direct_comparisons_form: @new_params}
        expect(response.status).to eql 302
        expect(response).to redirect_to(root)
        follow_redirect!
      end
    end

    describe "redirections" do
      it "redirects Criteria comparison to criterion" do
        post criterion_direct_comparisons_path(root), params: {direct_comparisons_form: appraisal_attributes}
        expect(response.status).to eql 302
        expect(response).to redirect_to(root)
        follow_redirect!
      end

      it "redirects Criteria comparison to ratings" do
        post criterion_direct_comparisons_path(c1), params: {direct_comparisons_form: alt_params}
        expect(response.status).to eql 302
        expect(response).to redirect_to(criterion_ratings_path(c1))
        follow_redirect!
      end
    end

    describe "redirections for #update method comparing alternatives" do
      it "redirects Criteria comparison to ratings" do
        patch criterion_direct_comparisons_path(c1), params: {direct_comparisons_form: alt_params}
        expect(response.status).to eql 302
        expect(response).to redirect_to(criterion_ratings_path(c1))
        follow_redirect!
      end
    end
  
  end
end
