require 'rails_helper'

RSpec.describe "Ratings", type: :request do
  let(:bingley) { create :bingley, :with_articles }
  let(:bingleys_article) { bingley.articles.first }
  let(:member)  { bingleys_article.members.first }
  let(:root) { bingleys_article.criteria.first }
  let(:alternatives) {
    [
      create(:alternative, title: 'Alternative 1', article: bingleys_article),
      create(:alternative, title: 'Alternative 2', article: bingleys_article),
      create(:alternative, title: 'Alternative 3', article: bingleys_article),
    ]
  }
  let(:appraisal) { build :appraisal, member_id: member.id, criterion_id: root.id, appraisal_method:'DirectComparison'}
  let(:appraisal_attributes) {
    {:criterion_id=>root.id, :member_id=>member.id, :appraisal_method=>"DirectComparison", 
      :direct_comparisons_attributes=>{
        "2"=>{"value"=>"5", "score"=>"0.5", "score_n"=>"0.5", "rank"=>"1", "comparable_id"=>c3.id, "comparable_type"=>"Criterion", "title"=>c3.title}, 
        "1"=>{"value"=>"4", "score"=>"0.4", "score_n"=>"0.4", "rank"=>"2", "comparable_id"=>c2.id, "comparable_type"=>"Criterion", "title"=>c2.title}, 
        "0"=>{"value"=>"1", "score"=>"0.1", "score_n"=>"0.1", "rank"=>"3", "comparable_id"=>c1.id, "comparable_type"=>"Criterion", "title"=>c1.title}
      }
    }
  }

  context "with signed in user" do
    before(:each) {
      sign_in bingley
      @article = bingleys_article
    }

    describe "GET #index" do
      it "returns http success" do
        get criterion_ratings_path(root)
        expect(response).to have_http_status(:success)
      end

    end
  end

end
