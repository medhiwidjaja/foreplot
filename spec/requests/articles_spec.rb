require 'rails_helper'

RSpec.describe "Articles", type: :request do
  let (:darcy) { create :darcy }
  let (:bingley) { create :bingley }
  let (:article) { create :article }

  let(:valid_attributes) {
    { title: 'Good article by Bingley', description: 'This is my first article', user_id: bingley.id, slug: 'my-article', private: false, active: true }
  }
  let(:invalid_attributes) {
    { title: '', active: true }
  }

  context "without signed in user" do
    describe "GET #index" do
      it "returns a success response" do
        get articles_path
        expect(response).to redirect_to( new_user_session_path )
      end
    end

    describe "GET #show" do
      it "redirects to sign in page" do
        article = Article.create! valid_attributes
        get articles_path(article)
        expect(response.body).to include('You need to sign in or sign up before continuing')
      end
    end
  end

  context "with signed in user" do
    before(:each) {
      sign_in bingley
    }

    describe "GET #index" do
      it "returns a success response" do
        Article.create! valid_attributes
        get articles_path
        expect(response).to be_successful
      end
    end

    describe "GET #show" do
      it "returns a success response" do
        article = Article.create! valid_attributes
        get articles_path(article)
        expect(response).to be_successful
      end
    end

    describe "GET #new" do
      it "returns a success response" do
        get new_article_path
        expect(response).to be_successful
      end
    end

    describe "GET #edit" do
      it "returns a success response" do
        article = Article.create! valid_attributes
        get edit_article_path(article)
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Article" do
          expect {
            post articles_path, params: {article: valid_attributes}
          }.to change(Article, :count).by(1)
        end

        it "redirects to the created article" do
          post articles_path, params: {article: valid_attributes}
          expect(response).to redirect_to(Article.last)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'new' template)" do
          post articles_path, params: {article: invalid_attributes}
          expect(response).to be_successful
          expect(response).to render_template(:new)
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          { title: 'My inactive article', description: '', slug: 'my-article', private: false, active: false }
        }

        it "updates the requested article" do
          article = Article.create! valid_attributes
          put article_path(article), params: {article: new_attributes}
          article.reload
          expect(article.active).to eq(false) 
        end

        it "redirects to the article" do
          article = Article.create! valid_attributes
          put article_path(article), params: {article: valid_attributes}
          expect(response).to redirect_to(article)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'edit' template)" do
          article = Article.create! valid_attributes
          put article_path(article), params: {article: invalid_attributes}
          expect(response).to render_template('edit')
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested article" do
        article = Article.create! valid_attributes
        expect {
          delete article_path(article.to_param)
        }.to change(Article, :count).by(-1)
      end

      it "redirects to the articles list" do
        article = Article.create! valid_attributes
        delete article_path(article)
        expect(response).to redirect_to(articles_url)
      end
    end

    describe "showing an article" do
      it "shows the left menu panel" do
        Article.create! valid_attributes
        get article_path article
        expect(response).to render_template("articles/_sidepanel")
        expect(response).to render_template("articles/_article_content")
        expect(response).to render_template("shared/_model_edit_navbar")
      end
    end
  end

  describe "GET my articles" do
    let (:darcys_article) {{ title: "An article by Darcy", user_id: darcy.id }}
    it "shows a list of the articles I created" do
      Article.create! valid_attributes
      #Article.create! darcys_article
      sign_in darcy
      expect {
        post articles_path, params: {article: darcys_article}
      }.to change(Article, :count).by(1)
      get my_articles_path
      expect(response.body).to include("An article by Darcy")
      expect(response.body).not_to include("Good article by Bingley")
    end
  end

end
