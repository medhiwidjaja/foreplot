require 'rails_helper'

RSpec.describe "Assays", type: :request do
  let(:bingley) { create :bingley, :with_articles }
  let(:bingleys_article) { bingley.articles.first }
  let(:root) { create(:criterion, article_id: bingleys_article.id) }
  let(:assay_attributes) { attributes_for :assay }
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
        get criterion_assay_direct_path(@root)
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      it "creates a new assay" do
        expect {
          post create_criterion_assay_path(root), params: {assay: assay_attributes}
        }.to change(Assay, :count).by(1)
      end

      it "should save related direct comparisons" do
        expect {
          post create_criterion_assay_path(root), params: {assay: {assay_method: 'Direct',
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
        assay = @root.assay
        put update_assay_path(assay), params: {assay: new_attributes}
        assay.reload
        expect(assay.direct_comparisons.first).to eq(99) 
      end
    end
  
  end
end
