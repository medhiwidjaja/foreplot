require 'rails_helper'

RSpec.describe "Ratings", type: :request do

  include_context "comparisons context for value tree" 

  context "with signed in user" do
    before(:each) {
      sign_in bingley
    }

    describe "GET #index" do
      it "returns http success" do
        get article_ratings_path(article)
        expect(response).to have_http_status(:success)
      end

      it "renders templates" do
        get article_ratings_path(article)
        expect(response).to render_template(:index)
        expect(response).to render_template('ratings/_sidepanel')
        expect(response.body).to include("Select one of the criteria at left to rate the alternatives")
      end
    end

    describe "GET #show" do
      it "returns http success" do
        get criterion_ratings_path(root)
        expect(response).to have_http_status(:success)
      end

      it "renders templates" do
        get criterion_ratings_path(root)
        expect(response).to render_template(:show)
        expect(response).to render_template('ratings/_sidepanel')
      end

      it "displays table of alternative ratings" do
        get criterion_ratings_path(c1)
        expect(response.body).to include("Alternative ratings with respect to:")
        expect(response.body).to include(c1.title)
        expect(response.body).to include("Alternative scores")
        expect(response.body).to include(alt1.title)
        expect(response.body).to include(alt2.title)
      end
    end
  end

  context "without signed in user with private article" do
    before {
      article.update private: true
    }
    it "get #index redirects to root page" do
      get article_ratings_path(article)
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include('You are not authorized')
    end

    it "#show redirects to root page" do
      get criterion_ratings_path(c1)
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include('You are not authorized')
    end
  end

  context "without signed in user with public article" do
    before {
      article.update private: false
    }
    it "get #index" do
      get article_ratings_path(article)
      expect(response).to be_successful
    end

    it "get #show" do
      get criterion_ratings_path(c1)
      expect(response).to be_successful
    end
  end

end
