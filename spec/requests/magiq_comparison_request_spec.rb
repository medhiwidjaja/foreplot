require 'rails_helper'

RSpec.describe "MagiqComparisons", type: :request do
  let(:bingley) { create :bingley, :with_articles }
  let(:bingleys_article) { bingley.articles.first }
  let(:member)  { bingleys_article.members.first }
  let(:root) { bingleys_article.criteria.first }
  let(:appraisal) { build :appraisal, member_id: member.id, criterion_id: criterion.id, appraisal_method:'MagiqComparison', rank_method: 'rank_order_centroid'}
  let(:c1) { create :criterion, article:bingleys_article, parent:root }
  let(:c2) { create :criterion, article:bingleys_article, parent:root }
  let(:c3) { create :criterion, article:bingleys_article, parent:root }
  let(:appraisal_attributes)    {
    {:criterion_id=>root.id, :member_id=>member.id, :appraisal_method=>"MagiqComparison", rank_method: 'rank_order_centroid', 
      :magiq_comparisons_attributes=>{
        "0"=>{"rank"=>"1", "comparable_id"=>c1.id, "comparable_type"=>"Criterion", "title"=>c1.title}, 
        "1"=>{"rank"=>"2", "comparable_id"=>c2.id, "comparable_type"=>"Criterion", "title"=>c2.title}, 
        "2"=>{"rank"=>"3", "comparable_id"=>c3.id, "comparable_type"=>"Criterion", "title"=>c3.title}
      }
    }
  }
  let(:invalid_attributes) {
    { title: '' }
  }
  let(:alt1) { create :alternative, article: bingleys_article }
  let(:alt2) { create :alternative, article: bingleys_article }
  let(:alt3) { create :alternative, article: bingleys_article }
  let(:alt_params)    {
    {:criterion_id=>c1.id, :member_id=>member.id, :appraisal_method=>"MagiqComparison", rank_method: 'rank_order_centroid', 
      :magiq_comparisons_attributes=>{
        "0"=>{"rank"=>"1", "comparable_id"=>alt1.id, "comparable_type"=>"Alternative", "title"=>alt1.title}, 
        "1"=>{"rank"=>"2", "comparable_id"=>alt2.id, "comparable_type"=>"Alternative", "title"=>alt2.title}, 
        "2"=>{"rank"=>"3", "comparable_id"=>alt3.id, "comparable_type"=>"Alternative", "title"=>alt3.title}
      }
    }
  }

  context "comparing sub-criteria" do
    before(:each) {
      sign_in bingley
      @article = bingleys_article
      @root = root
      2.times { create(:criterion, parent_id: @root.id) }
    }

    describe "GET #new" do
      it "returns a success response" do
        get criterion_new_magiq_comparisons_path(@root)
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
      let(:dc1) { MagiqComparison.new(rank: 3, score: 0.17, comparable_id:c1.id, comparable_type: 'Criterion') }
      let(:dc2) { MagiqComparison.new(rank: 2, score: 0.33, comparable_id:c2.id, comparable_type: 'Criterion') }
      let(:dc3) { MagiqComparison.new(rank: 1, score: 0.50, comparable_id:c3.id, comparable_type: 'Criterion') }
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
        persisted_appraisal = @root.appraisals.first
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
      end
    end
  
    describe "redirections for #create method" do
      it "redirects Criteria comparison to criterion" do
        post criterion_magiq_comparisons_path(root), params: {magiq_comparisons_form: appraisal_attributes}
        expect(response.status).to eql 302
        expect(response).to redirect_to(root)
        follow_redirect!
      end

      it "redirects Criteria comparison to ratings" do
        post criterion_magiq_comparisons_path(c1), params: {magiq_comparisons_form: alt_params}
        expect(response.status).to eql 302
        expect(response).to redirect_to(criterion_ratings_path(c1))
        follow_redirect!
      end
    end

    describe "redirections for #update method comparing alternatives" do
      it "redirects Criteria comparison to ratings" do
        patch criterion_magiq_comparisons_path(c1), params: {magiq_comparisons_form: alt_params}
        expect(response.status).to eql 302
        expect(response).to redirect_to(criterion_ratings_path(c1))
        follow_redirect!
      end
    end

  end
end
