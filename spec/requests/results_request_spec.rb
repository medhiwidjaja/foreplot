require 'rails_helper'

RSpec.describe "Results", type: :request do

  include_context "comparisons context for value tree" 

  context "with signed in user" do
    before(:each) {
      sign_in @bingley
    }

    describe "GET #index" do
      it "returns http success" do
        get article_results_path(@bingleys_article)
        expect(response).to have_http_status(:success)
      end

      it "shows a criteria tree on the sidepanel" do
        get article_results_path(@bingleys_article)
        expect(response).to render_template("results/_sidepanel")
      end

      it "shows a table of the result" do
        get article_results_path(@bingleys_article)
        expect(response).to render_template("results/_rank_table")
        expect(response.body).to include(@alt1.title)
        expect(response.body).to include(@alt2.title)
      end
    end

    describe "GET #index json format" do
      it "returns valid json" do
        get article_results_path(@bingleys_article, format: :json)
        expect(response.content_type).to eq("application/json")   
        expect(body_as_json).to include(
          id:    @alt2.id, 
          title: @alt2.title, 
          rank:  1, 
          score: 0.6,
          ratio: 1.0
        )
      end
    end
  end

end
