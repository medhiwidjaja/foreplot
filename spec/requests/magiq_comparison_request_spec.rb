require 'rails_helper'

RSpec.describe "MagiqComparisons", type: :request do

  include_context "criteria context for comparisons" 

  let(:appraisal) { build :appraisal, member_id: member.id, criterion_id: root.id, appraisal_method:'MagiqComparison', rank_method: 'rank_order_centroid'}
  let(:appraisal_attributes)    {
    {:criterion_id=>root.id, :member_id=>member.id, :appraisal_method=>"MagiqComparison", rank_method: 'rank_order_centroid', 
      :magiq_comparisons_attributes=>{
        "0"=>{"rank"=>"1", "comparable_id"=>c1.id, "comparable_type"=>"Criterion", "title"=>c1.title, "position"=>c1.position}, 
        "1"=>{"rank"=>"2", "comparable_id"=>c2.id, "comparable_type"=>"Criterion", "title"=>c2.title, "position"=>c2.position}, 
        "2"=>{"rank"=>"3", "comparable_id"=>c3.id, "comparable_type"=>"Criterion", "title"=>c3.title, "position"=>c3.position}
      }
    }
  }
  let(:invalid_attributes) {
    { title: '' }
  }
  let(:alt_params)    {
    {:criterion_id=>c1.id, :member_id=>member.id, :appraisal_method=>"MagiqComparison", rank_method: 'rank_order_centroid', 
      :magiq_comparisons_attributes=>{
        "0"=>{"rank"=>"1", "comparable_id"=>alt1.id, "comparable_type"=>"Alternative", "title"=>alt1.title, "position"=>alt1.position}, 
        "1"=>{"rank"=>"2", "comparable_id"=>alt2.id, "comparable_type"=>"Alternative", "title"=>alt2.title, "position"=>alt2.position}, 
        "2"=>{"rank"=>"3", "comparable_id"=>alt3.id, "comparable_type"=>"Alternative", "title"=>alt3.title, "position"=>alt3.position}
      }
    }
  }
  let(:invalid_params)    {
    {:criterion_id=>c1.id, :member_id=>member.id, :appraisal_method=>"MagiqComparison", rank_method: 'rank_order_centroid', 
      :magiq_comparisons_attributes=>{
        "0"=>{"rank"=>"1", "comparable_id"=>alt1.id, "comparable_type"=>"Alternative", "title"=>alt1.title, "position"=>alt1.position}, 
        "1"=>{"rank"=>"1", "comparable_id"=>alt2.id, "comparable_type"=>"Alternative", "title"=>alt2.title, "position"=>alt2.position}, 
        "2"=>{"rank"=>"3", "comparable_id"=>alt3.id, "comparable_type"=>"Alternative", "title"=>alt3.title, "position"=>alt3.position}
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
        get criterion_new_magiq_comparisons_path(root)
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      it "creates a new appraisal" do
        expect {
          post criterion_magiq_comparisons_path(root), params: {magiq_comparisons_form: appraisal_attributes}
        }.to change(Appraisal, :count).by(1)
      end

      it "should save related magiq comparisons" do
        expect {
          post criterion_magiq_comparisons_path(root), params: {magiq_comparisons_form: appraisal_attributes}
        }.to change(MagiqComparison, :count).by(3)
      end
    end

    describe "PATCH #update" do
      let(:persisted_appraisal) { create :appraisal, member_id: member.id, criterion_id: root.id, appraisal_method:'MagiqComparison', rank_method:'rank_sum', is_complete:true, comparable_type: 'Criterion' }
      let(:dc1) { MagiqComparison.new(rank: 3, score: 0.17, comparable_id:c1.id, comparable_type: 'Criterion', "position"=>c1.position) }
      let(:dc2) { MagiqComparison.new(rank: 2, score: 0.33, comparable_id:c2.id, comparable_type: 'Criterion', "position"=>c2.position) }
      let(:dc3) { MagiqComparison.new(rank: 1, score: 0.50, comparable_id:c3.id, comparable_type: 'Criterion', "position"=>c3.position) }
      let(:persisted_comparisons) { [ dc1, dc2, dc3 ] }

      before(:each) do
        persisted_appraisal.magiq_comparisons << persisted_comparisons
        @new_params = {:criterion_id=>root.id, :member_id=>member.id, :appraisal_method=>"MagiqComparison", :rank_method=>"rank_sum",
          :magiq_comparisons_attributes=>{
            "2"=>{"score"=>"0.50", "score_n"=>"0.50", "rank"=>"1", "id"=>persisted_appraisal.magiq_comparisons.first.id}, 
            "1"=>{"score"=>"0.33", "score_n"=>"0.33", "rank"=>"2", "id"=>persisted_appraisal.magiq_comparisons.second.id}, 
            "0"=>{"score"=>"0.17", "score_n"=>"0.17", "rank"=>"3", "id"=>persisted_appraisal.magiq_comparisons.third.id}
          }
        }
      end

      it "updates the comparison with new values" do
        persisted_appraisal = root.appraisals.first
        patch criterion_magiq_comparisons_path(root), params: {magiq_comparisons_form: @new_params}
        persisted_appraisal.reload
        comparisons = persisted_appraisal.magiq_comparisons.reload
        expect(comparisons.order(:id).map(&:score_n)).to eq([0.50, 0.33, 0.17])
        expect(comparisons.order(:id).map(&:rank)).to eq([1, 2, 3])
      end

      it "redirects Criteria comparison to criterion" do
        patch criterion_magiq_comparisons_path(root), params: {magiq_comparisons_form: @new_params}
        expect(response.status).to eql 302
        expect(response).to redirect_to(root)
        follow_redirect!
        expect(response).to render_template(:show)
        expect(response.body).to include('Magiq comparisons updated')
        # expect(response.body).to include(c1.title)
        # expect(response.body).to include(c2.title)
        # expect(response.body).to include(c3.title)
      end
    end
  
    describe "redirections for #create method" do
      it "redirects Criteria comparison to criterion" do
        post criterion_magiq_comparisons_path(root), params: {magiq_comparisons_form: appraisal_attributes}
        expect(response.status).to eql 302
        expect(response).to redirect_to(root)
        follow_redirect!
        expect(response).to render_template(:show)
        expect(response.body).to include(c1.title)
        expect(response.body).to include(c2.title)
        expect(response.body).to include(c3.title)
      end

      it "redirects Criteria comparison to ratings" do
        post criterion_magiq_comparisons_path(c1), params: {magiq_comparisons_form: alt_params}
        expect(response.status).to eql 302
        expect(response).to redirect_to(criterion_ratings_path(c1))
        follow_redirect!
        expect(response).to render_template(:show)
        expect(response.body).to include(alt1.title)
        expect(response.body).to include(alt2.title)
        expect(response.body).to include(alt3.title)
      end
    end

    describe "redirections for #update method comparing alternatives" do
      it "redirects Criteria comparison to ratings" do
        patch criterion_magiq_comparisons_path(c1), params: {magiq_comparisons_form: alt_params}
        expect(response.status).to eql 302
        expect(response).to redirect_to(criterion_ratings_path(c1))
        follow_redirect!
        expect(response).to render_template(:show)
        expect(response.body).to include(alt1.title)
        expect(response.body).to include(alt2.title)
        expect(response.body).to include(alt3.title)
      end
    end

    describe "with invalid params" do
      it "won't save the comparisons" do
        expect {
          post criterion_magiq_comparisons_path(root), params: {magiq_comparisons_form: invalid_params}
        }.to change(Appraisal, :count).by(0)
      end

      it "displays an error message" do
        post criterion_magiq_comparisons_path(root), params: {magiq_comparisons_form: invalid_params}
        expect(response).to render_template(:new)
        expect(response.body).to include('Interior ranks are empty: 2')
      end
    end
  end

  context "without signed in user" do
    it "get #new redirects to login page" do
      get criterion_new_magiq_comparisons_path(criterion)
      expect(response.status).to eql 302
      expect(response).to redirect_to(new_user_session_url)
    end

    it "#edit redirects to login page" do
      get criterion_edit_magiq_comparisons_path(criterion)
      expect(response.status).to eql 302
      expect(response).to redirect_to(new_user_session_url)
    end

    it "POST redirects to login page" do
      post criterion_magiq_comparisons_path(root), params: {magiq_comparisons_form: appraisal_attributes}
      expect(response.status).to eql 302
      expect(response).to redirect_to(new_user_session_url)
    end

    it "PATCH redirects to login page" do
      post criterion_magiq_comparisons_path(root), params: {magiq_comparisons_form: appraisal_attributes}
      expect(response.status).to eql 302
      expect(response).to redirect_to(new_user_session_url)
    end
  end
end
