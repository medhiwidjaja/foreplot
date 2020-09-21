require 'rails_helper'

RSpec.describe "AHPComparisons", type: :request do

  include_context "criteria context for comparisons" 

  let(:appraisal) { build :appraisal, member_id: member.id, criterion_id: criterion.id, appraisal_method:'AHPComparison'}

  context "comparing sub-criteria" do
    let(:appraisal_attributes)    {
      {:criterion_id=>criterion.id, :member_id=>member.id, :appraisal_method=>"AHPComparison", 
        :ahp_comparisons_attributes=>{
          "0"=>{"comparable_id"=>c1.id, "comparable_type"=>"Criterion", "title"=>c1.title, "position"=>c1.position}, 
          "1"=>{"comparable_id"=>c2.id, "comparable_type"=>"Criterion", "title"=>c2.title, "position"=>c2.position}, 
          "2"=>{"comparable_id"=>c3.id, "comparable_type"=>"Criterion", "title"=>c3.title, "position"=>c3.position}
        },
        :pairwise_comparisons_attributes=>{
          "0"=>{"comparable1_id"=>c1.id, "comparable1_type"=>"Criterion", "comparable2_id"=>c2.id, "comparable2_type"=>"Criterion", "value"=>0.25}, 
          "1"=>{"comparable1_id"=>c1.id, "comparable1_type"=>"Criterion", "comparable2_id"=>c3.id, "comparable2_type"=>"Criterion", "value"=>4}, 
          "2"=>{"comparable1_id"=>c2.id, "comparable1_type"=>"Criterion", "comparable2_id"=>c3.id, "comparable2_type"=>"Criterion", "value"=>9}
        }
      }
    }
    
    before(:each) {
      sign_in bingley
    }

    describe "GET #new" do
      it "returns a success response" do
        get criterion_new_ahp_comparisons_path(criterion)
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      it "creates a new appraisal" do
        expect {
          post criterion_ahp_comparisons_path(criterion), params: {ahp_comparisons_form: appraisal_attributes}
        }.to change(Appraisal, :count).by(1)
      end

      it "should save related AHP comparisons" do
        expect {
          post criterion_ahp_comparisons_path(criterion), params: {ahp_comparisons_form: appraisal_attributes}
        }.to change(AHPComparison, :count).by(3)
      end

      it "save the calculated score values" do
        post criterion_ahp_comparisons_path(criterion), params: {ahp_comparisons_form: appraisal_attributes}
        comparisons = AHPComparison.all.order(:comparable_id)
        expect(comparisons.pluck(:score).map{|x| "%0.2f" % x}).to eq(["0.22", "0.72", "0.07"])
      end

      it "should save related pairwise comparisons" do
        expect {
          post criterion_ahp_comparisons_path(criterion), params: {ahp_comparisons_form: appraisal_attributes}
        }.to change(PairwiseComparison, :count).by(3)
      end

      it "should sets appraisal is_complete to true" do
        post criterion_ahp_comparisons_path(criterion), params: {ahp_comparisons_form: appraisal_attributes}
        expect( criterion.appraisals.where(member: member).take.is_complete ).to eq(true)
      end
    end

    describe "GET #edit" do
      it "returns a success response" do
        get criterion_edit_ahp_comparisons_path(criterion)
        expect(response).to be_successful
      end
    end

    describe "PATCH #update" do
      let(:persisted_appraisal) { create :appraisal, member_id: member.id, criterion_id: criterion.id, is_valid: true,
                                  appraisal_method:'AHPComparison', is_complete:true, comparable_type: 'Criterion' }
      let(:ahp1) { create(:ahp_comparison, rank: 1, score: 0.1, comparable_id:c1.id, comparable_type: 'Criterion', position:c1.position, appraisal: persisted_appraisal) }
      let(:ahp2) { create(:ahp_comparison, rank: 2, score: 0.2, comparable_id:c2.id, comparable_type: 'Criterion', position:c2.position, appraisal: persisted_appraisal) }
      let(:ahp3) { create(:ahp_comparison, rank: 3, score: 0.3, comparable_id:c3.id, comparable_type: 'Criterion', position:c3.position, appraisal: persisted_appraisal) }

      let(:pw1) { create(:pairwise_comparison, comparable1_id: c1.id, comparable2_id: c2.id, value: 1, appraisal: persisted_appraisal) }
      let(:pw2) { create(:pairwise_comparison, comparable1_id: c1.id, comparable2_id: c3.id, value: 1, appraisal: persisted_appraisal) }
      let(:pw3) { create(:pairwise_comparison, comparable1_id: c2.id, comparable2_id: c3.id, value: 1, appraisal: persisted_appraisal) }
      
      before(:each) do
        @new_params = {
          :criterion_id=>criterion.id, :member_id=>member.id, :appraisal_method=>"AHPComparison",
          :ahp_comparisons_attributes => {
            ahp1.id.to_s=>{"comparable_id"=>c1.id, "comparable_type"=>"Criterion", "title"=>c1.title, "id"=>ahp1.id}, 
            ahp2.id.to_s=>{"comparable_id"=>c2.id, "comparable_type"=>"Criterion", "title"=>c2.title, "id"=>ahp2.id}, 
            ahp3.id.to_s=>{"comparable_id"=>c3.id, "comparable_type"=>"Criterion", "title"=>c3.title, "id"=>ahp3.id}
          },
          :pairwise_comparisons_attributes => {
            pw1.id.to_s=>{"comparable1_id" => "#{c1.id}", "comparable2_id" => "#{c2.id}", "value"=>"0.25", "id"=>pw1.id }, 
            pw2.id.to_s=>{"comparable1_id" => "#{c1.id}", "comparable2_id" => "#{c3.id}", "value"=>"4", "id"=>pw2.id }, 
            pw3.id.to_s=>{"comparable1_id" => "#{c2.id}", "comparable2_id" => "#{c3.id}", "value"=>"9", "id"=>pw3.id }
          }
        }
      end

      it "persists the original values" do
        expect(persisted_appraisal.ahp_comparisons.order_by_position.map{|x| x.score}).to eq([0.1, 0.2, 0.3])
      end

      it "updates the comparisons with new values" do
        patch criterion_ahp_comparisons_path(criterion), params: {ahp_comparisons_form: @new_params}
        comparisons = persisted_appraisal.ahp_comparisons.order(:comparable_id)
        expect(comparisons.pluck(:score).map{|x| "%0.2f" % x}).to eq(["0.22", "0.72", "0.07"])
      end

      it "redirects Criteria comparison to criterion" do
        patch criterion_ahp_comparisons_path(criterion), params: {ahp_comparisons_form: @new_params}
        expect(response.status).to eql 302
        expect(response).to redirect_to(criterion)
        follow_redirect!
      end
    end

    describe "redirections" do
      it "redirects Criteria comparison to criterion" do
        post criterion_ahp_comparisons_path(criterion), params: {ahp_comparisons_form: appraisal_attributes}
        expect(response.status).to eql 302
        expect(response).to redirect_to(criterion)
        follow_redirect!
      end
    end
  end

  context "comparing alternatives" do

    let(:alt_params)    {
      {:criterion_id=>c1.id, :member_id=>member.id, :appraisal_method=>"AHPComparison",
        :ahp_comparisons_attributes=>{
          "0"=>{"comparable_id"=>alt1.id, "comparable_type"=>alt1.class, "title"=>alt1.title}, 
          "1"=>{"comparable_id"=>alt2.id, "comparable_type"=>alt1.class, "title"=>alt2.title}, 
          "2"=>{"comparable_id"=>alt3.id, "comparable_type"=>alt1.class, "title"=>alt3.title}
        },
        :pairwise_comparisons_attributes=>{
          "0"=>{"comparable1_id"=>alt1.id, "comparable1_type"=>"Alternative", "comparable2_id"=>alt2.id, "comparable2_type"=>"Alternative", "value"=>0.25}, 
          "1"=>{"comparable1_id"=>alt1.id, "comparable1_type"=>"Alternative", "comparable2_id"=>alt3.id, "comparable2_type"=>"Alternative", "value"=>4}, 
          "2"=>{"comparable1_id"=>alt2.id, "comparable1_type"=>"Alternative", "comparable2_id"=>alt3.id, "comparable2_type"=>"Alternative", "value"=>9}
        }
      }
    }

    before(:each) {
      sign_in bingley
    }

    describe "redirections" do
      it "redirects Criteria comparison to ratings" do
        post criterion_ahp_comparisons_path(c1), params: {ahp_comparisons_form: alt_params}
        expect(response.status).to eql 302
        expect(response).to redirect_to(criterion_ratings_path(c1))
        follow_redirect!
      end
    end

    describe "redirections for #update method comparing alternatives" do
      it "redirects Criteria comparison to ratings" do
        patch criterion_ahp_comparisons_path(c1), params: {ahp_comparisons_form: alt_params}
        expect(response.status).to eql 302
        expect(response).to redirect_to(criterion_ratings_path(c1))
        follow_redirect!
      end
    end
  
  end
end
