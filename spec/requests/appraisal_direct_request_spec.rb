require 'rails_helper'

RSpec.describe "Appraisals", type: :request do
  let(:bingley) { create :bingley, :with_articles }
  let(:bingleys_article) { bingley.articles.first }
  let(:root) { create(:criterion, article_id: bingleys_article.id) }
  let(:appraisal_attributes) { attributes_for :appraisal }
  let(:invalid_attributes) {
    { title: '' }
  }

  context "with signed in user" do
    before(:each) {
      sign_in bingley
      @article = bingleys_article
      @root = root
      2.times { create(:criterion, parent_id: @root.id) }
    }

    describe "GET #direct" do
      it "returns a success response" do
        get criterion_appraisal_direct_path(@root)
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      let(:appraisal_with_direct_comparison_attributes) {
        attributes_for :appraisal, :with_direct_comparisons
      }
      it "creates a new appraisal" do
        expect {
          post create_criterion_appraisal_path(root), params: {appraisal: appraisal_with_direct_comparison_attributes}
        }.to change(Appraisal, :count).by(1)
      end

      it "should save related direct comparisons" do
        expect {
          post create_criterion_appraisal_path(root), params: {appraisal: {appraisal_method: 'Direct',
            direct_comparisons_attributes: [
              build(:direct_comparison, comparable: @root.children.first, comparable_type: 'Criterion').attributes, 
              build(:direct_comparison, comparable: @root.children.last, comparable_type: 'Criterion').attributes
            ]}
          }
        }.to change(DirectComparison, :count).by(2)
      end
    end

    describe "PUT #update" do
      it "updates the comparison with new values" do
        appraisal = @root.appraisal
        put update_appraisal_path(appraisal), params: {appraisal: new_attributes}
        appraisal.reload
        expect(appraisal.direct_comparisons.first).to eq(99) 
      end
    end
  
  end
end
