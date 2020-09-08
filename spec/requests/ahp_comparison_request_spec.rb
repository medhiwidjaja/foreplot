require 'rails_helper'

RSpec.describe "AHPComparisons", type: :request do
  let(:bingley) { create :bingley, :with_articles }
  let(:bingleys_article) { bingley.articles.first }
  let(:member)  { bingleys_article.members.first }
  let(:criterion) { bingleys_article.criteria.first }
  let(:appraisal) { build :appraisal, member_id: member.id, criterion_id: criterion.id, appraisal_method:'AHPComparison'}
  let(:c1) { create :criterion, article:bingleys_article, parent:criterion }
  let(:c2) { create :criterion, article:bingleys_article, parent:criterion }
  let(:c3) { create :criterion, article:bingleys_article, parent:criterion }
  let(:appraisal_attributes)    {
    {:criterion_id=>criterion.id, :member_id=>member.id, :appraisal_method=>"AHPComparison", 
      :ahp_comparisons_attributes=>{
        "0"=>{"comparable_id"=>c1.id, "comparable_type"=>"Criterion", "title"=>c1.title}, 
        "1"=>{"comparable_id"=>c2.id, "comparable_type"=>"Criterion", "title"=>c2.title}, 
        "2"=>{"comparable_id"=>c3.id, "comparable_type"=>"Criterion", "title"=>c3.title}
      },
      :pairwise_comparisons_attributes=>{
        "0"=>{"comparable1_id"=>c1.id, "comparable1_type"=>"Criterion", "comparable2_id"=>c2.id, "comparable2_type"=>"Criterion", "value"=>0.25}, 
        "1"=>{"comparable1_id"=>c1.id, "comparable1_type"=>"Criterion", "comparable2_id"=>c3.id, "comparable2_type"=>"Criterion", "value"=>4}, 
        "2"=>{"comparable1_id"=>c2.id, "comparable1_type"=>"Criterion", "comparable2_id"=>c3.id, "comparable2_type"=>"Criterion", "value"=>9}
      }
    }
  }
  let(:alt1) { create :alternative, article: bingleys_article }
  let(:alt2) { create :alternative, article: bingleys_article }
  let(:alt3) { create :alternative, article: bingleys_article }
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

  context "comparing sub-criteria" do
    before(:each) {
      sign_in bingley
      @article = bingleys_article
      @criterion = criterion
    }

    describe "GET #new" do
      it "returns a success response" do
        get criterion_new_ahp_comparisons_path(@criterion)
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
        get criterion_edit_ahp_comparisons_path(@criterion)
        expect(response).to be_successful
      end
    end

    describe "PATCH #update" do
      let(:persisted_appraisal) { create :appraisal, member_id: member.id, criterion_id: criterion.id, is_valid: true,
                                  appraisal_method:'AHPComparison', is_complete:true, comparable_type: 'Criterion' }
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
        @new_params = {
          :criterion_id=>criterion.id, :member_id=>member.id, :appraisal_method=>"AHPComparison",
          :ahp_comparisons_attributes => {
            "0"=>{"comparable_id"=>c1.id, "comparable_type"=>"Criterion", "title"=>c1.title, "id"=>persisted_appraisal.ahp_comparisons.first.id}, 
            "1"=>{"comparable_id"=>c2.id, "comparable_type"=>"Criterion", "title"=>c2.title, "id"=>persisted_appraisal.ahp_comparisons.second.id}, 
            "2"=>{"comparable_id"=>c3.id, "comparable_type"=>"Criterion", "title"=>c3.title, "id"=>persisted_appraisal.ahp_comparisons.last.id}
          },
          :pairwise_comparisons_attributes => {
            "0"=>{"comparable1_id" => "#{c1.id}", "comparable2_id" => "#{c2.id}", "value"=>"0.25", "id"=>persisted_appraisal.pairwise_comparisons.first.id }, 
            "1"=>{"comparable1_id" => "#{c1.id}", "comparable2_id" => "#{c3.id}", "value"=>"4", "id"=>persisted_appraisal.pairwise_comparisons.second.id }, 
            "2"=>{"comparable1_id" => "#{c2.id}", "comparable2_id" => "#{c3.id}", "value"=>"9", "id"=>persisted_appraisal.pairwise_comparisons.last.id }
          }
        }
      end

      it "persists the original values" do
        expect(persisted_appraisal.ahp_comparisons.order(:id).map{|x| x.score}).to eq([0.3, 0.3, 0.3])
      end

      it "updates the comparison with new values" do
        patch criterion_ahp_comparisons_path(criterion), params: {ahp_comparisons_form: @new_params}
        comparisons = persisted_appraisal.ahp_comparisons.reload
        expect(comparisons.order(:comparable_id).map{|x| "%0.2f" % x.score}).to eq(["0.22", "0.72", "0.07"])
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
