require 'rails_helper'

RSpec.describe "Alternative", type: :request do
  let (:bingley) { create :bingley, :with_articles }
  let! (:bingleys_article) { bingley.articles.first }

  let(:valid_attributes) {
    { title: 'Alternative 1', article_id: bingleys_article.id, abbrev: 'Alt 1' }
  }
  let(:invalid_attributes) {
    { title: '' }
  }

  context "with signed in user" do
    before(:each) {
      sign_in bingley
      @article = bingleys_article
    }

    describe "GET #index" do
      it "returns a success response" do
        @article.alternatives.create! valid_attributes
        get article_alternatives_path(@article)
        expect(response).to be_successful
      end
    end

    describe "GET #show" do
      it "returns a success response" do
        alternative = @article.alternatives.create! valid_attributes
        get alternative_path(alternative)
        expect(response).to be_successful
      end
    end

    describe "GET #new" do
      it "returns a success response" do
        get new_article_alternative_path(@article)
        expect(response).to be_successful
      end
    end

    describe "GET #edit" do
      it "returns a success response" do
        alternative = @article.alternatives.create! valid_attributes
        get edit_alternative_path(alternative)
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new alternative" do
          expect {
            post article_alternatives_path(@article), params: {alternative: valid_attributes}
          }.to change(Alternative, :count).by(1)
        end

        it "redirects to the created alternative" do
          post article_alternatives_path(@article), params: {alternative: valid_attributes}
          expect(response).to redirect_to(@article.alternatives.last)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'new' template)" do
          post article_alternatives_path(@article), params: {alternative: invalid_attributes}
          expect(response).to be_successful
          expect(response).to render_template(:new)
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          { title: 'A new title' }
        }

        it "updates the requested alternative" do
          alternative = @article.alternatives.create! valid_attributes
          put alternative_path(alternative), params: {alternative: new_attributes}
          alternative.reload
          expect(alternative.title).to eq('A new title') 
        end

        it "redirects to the alternative" do
          alternative = @article.alternatives.create! valid_attributes
          put alternative_path(alternative), params: {alternative: valid_attributes}
          expect(response).to redirect_to(alternative)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'edit' template)" do
          alternative = @article.alternatives.create! valid_attributes
          put alternative_path(alternative), params: {alternative: invalid_attributes}
          expect(response).to render_template('edit')
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested alternative" do
        alternative = @article.alternatives.create! valid_attributes
        expect {
          delete alternative_path(alternative.to_param)
        }.to change(Alternative, :count).by(-1)
      end

      it "redirects to the alternatives list" do
        alternative = @article.alternatives.create! valid_attributes
        delete alternative_path(alternative)
        expect(response).to redirect_to(article_alternatives_url(@article))
      end
    end

    describe "showing an alternative" do
      it "shows the left menu panel and model edit menu" do
        alternative = @article.alternatives.create! valid_attributes
        get article_alternatives_path(@article)
        expect(response).to render_template("alternatives/_sidepanel")
        expect(response).to render_template("shared/_model_edit_navbar")
      end
    end

    describe "updating ordering positions" do
      before {
        @alt1 = create :alternative, article: @article, position: 1
        @alt2 = create :alternative, article: @article, position: 2
      }
      it "accepts input and display the list in correct order" do
        expect {
          post update_all_article_alternatives_path(@article), params: {alternatives: {@alt1.id => {position: 2}, @alt2.id => {position: 1}} }, xhr: true
        }.to change { @alt1.reload.position }.from(1).to(2)
          .and change { @alt2.reload.position }.from(2).to(1)
      end
    end

  end

  context "without signed in user" do
    before {
      @alternative = bingleys_article.alternatives.create! valid_attributes
    }
    
    it "#new redirects to login page" do
      get new_article_alternative_path(bingleys_article)
      expect(response.status).to eql 302
      expect(response).to redirect_to(new_user_session_url)
    end

    it "#show redirects to login page" do
      get alternative_path(@alternative)
      expect(response.status).to eql 302
      expect(response).to redirect_to(new_user_session_url)
    end

    it "#edit redirects to login page" do
      get edit_alternative_path(@alternative)
      expect(response.status).to eql 302
      expect(response).to redirect_to(new_user_session_url)
    end

    it "POST redirects to login page" do
      post article_alternatives_path(bingleys_article), params: {alternative: valid_attributes}
      expect(response.status).to eql 302
      expect(response).to redirect_to(new_user_session_url)
    end

    it "PUT redirects to login page" do
      put alternative_path(@alternative), params: {alternative: valid_attributes}
      expect(response.status).to eql 302
      expect(response).to redirect_to(new_user_session_url)
    end

    it "DELETE redirects to login page" do
      delete alternative_path(@alternative)
      expect(response.status).to eql 302
      expect(response).to redirect_to(new_user_session_url)
    end
  end

end
