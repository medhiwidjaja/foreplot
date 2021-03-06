require 'rails_helper'

RSpec.describe "Results", type: :request do

  include_context "comparisons context for value tree" 

  context "with signed in user" do
    before(:each) {
      sign_in bingley
    }

    describe "GET #index" do
      it "returns http success" do
        get article_results_path(article)
        expect(response).to have_http_status(:success)
      end

      it "shows a criteria tree on the sidepanel" do
        get article_results_path(article)
        expect(response).to render_template("results/_sidepanel")
      end

      it "shows a chart" do
        get article_results_path(article)
        expect(response).to render_template("results/_chart")
      end

      it "show detail chart" do
        get article_results_path(article)
        expect(response).to render_template("results/_detail_chart")
      end

      it "shows a table of the result" do
        get article_results_path(article)
        expect(response).to render_template("results/_rank_table")
        expect(response.body).to include(alt1.title)
        expect(response.body).to include(alt2.title)
      end
    end

    describe "GET #index json format" do
      it "returns valid json" do
        get article_results_path(article, format: :json)
        expect(response.content_type).to eq("application/json; charset=utf-8")   
        expect(body_as_json).to include(
          id:    alt2.id, 
          title: alt2.title, 
          rank:  1, 
          score: 0.6,
          ratio: 1.0
        )
      end
    end

    describe "GET #chart json format" do
      it "returns chart data in json format" do
        get article_chart_path(article, format: :json)
        expect(response.content_type).to eq("application/json; charset=utf-8")   
        expect(body_as_json).to include(
          chart_data: [0.6, 0.4],
          names:      [alt2.title, alt1.title]
        )
      end
    end
  end

  context "without signed in user with private article" do
    before {
      article.update private: true
    }
    it "get #index redirects to login page" do
      get article_results_path(article)
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include('You are not authorized')
    end

    it "#chart redirects to login page" do
      get article_chart_path(article, format: :json)
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include('You are not authorized')
    end
  end

  context "without signed in user with public article" do
    before {
      article.update private: false
    }
    it "shows article results" do
      get article_results_path(article)
      expect(response).to be_successful
      expect(response).to render_template("results/_chart")
    end

    it "responds with json" do
      get article_chart_path(article, format: :json)
      expect(response).to be_successful
      expect(response.header['Content-Type']).to include 'application/json; charset=utf-8'
    end
  end
end
