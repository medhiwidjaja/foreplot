require 'rails_helper'

RSpec.describe "DirectComparisons", type: :request do
  let(:bingley) { create :bingley, :with_articles }
  let(:bingleys_article) { bingley.articles.first }
  let(:member)  { bingleys_article.members.first }
  let(:root) { bingleys_article.criteria.first }
  let(:appraisal) { build :appraisal, member_id: member.id, criterion_id: root.id, appraisal_method:'DirectComparison'}
  let(:c1) { create :criterion, article:bingleys_article, parent:root }
  let(:c2) { create :criterion, article:bingleys_article, parent:root }
  let(:c3) { create :criterion, article:bingleys_article, parent:root }
  let(:appraisal_attributes) {
    {:criterion_id=>root.id, :member_id=>member.id, :appraisal_method=>"DirectComparison", 
      :direct_comparisons_attributes=>{
        "2"=>{"value"=>"5", "score"=>"0.5", "score_n"=>"0.5", "rank"=>"1", "comparable_id"=>c3.id, "comparable_type"=>"Criterion", "title"=>c3.title}, 
        "1"=>{"value"=>"4", "score"=>"0.4", "score_n"=>"0.4", "rank"=>"2", "comparable_id"=>c2.id, "comparable_type"=>"Criterion", "title"=>c2.title}, 
        "0"=>{"value"=>"1", "score"=>"0.1", "score_n"=>"0.1", "rank"=>"3", "comparable_id"=>c1.id, "comparable_type"=>"Criterion", "title"=>c1.title}
      }
    }
  }
  let(:invalid_attributes) {
    { title: '' }
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
        get criterion_new_direct_comparisons_path(@root)
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

    describe "PUT #update" do
      let(:persisted_appraisal) { create :appraisal, member_id: member.id, criterion_id: root.id, appraisal_method:'DirectComparison', is_complete:true }
      let(:dc1) { DirectComparison.new(value: 100, rank: 3, score: 1, comparable_id:c1.id, comparable_type: 'Criterion') }
      let(:dc2) { DirectComparison.new(value: 200, rank: 2, score: 2, comparable_id:c2.id, comparable_type: 'Criterion') }
      let(:dc3) { DirectComparison.new(value: 400, rank: 1, score: 4, comparable_id:c3.id, comparable_type: 'Criterion') }
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
        persisted_appraisal = @root.appraisals.first
        patch criterion_direct_comparisons_path(root), params: {direct_comparisons_form: @new_params}
        persisted_appraisal.reload
        comparisons = persisted_appraisal.direct_comparisons.reload
        expect(comparisons.order(:score_n).map(&:score_n)).to eq([0.1, 0.4, 0.5])
        expect(comparisons.order(:value).map(&:value)).to eq([1.0, 4.0, 5.0])
      end
    end
  
  end
end
