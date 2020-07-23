require 'rails_helper'

RSpec.describe "Criterion", type: :request do
  let (:bingley) { create :bingley, :with_articles }
  let (:bingleys_article) { bingley.articles.first }
  let (:root) { create(:criterion, article_id: bingleys_article.id) }
  let(:valid_attributes) {
    { title: 'Criterion 1', article_id: bingleys_article.id, abbrev: 'C#1' }
  }
  let(:invalid_attributes) {
    { title: '' }
  }

  context "with signed in user" do
    before(:each) {
      sign_in bingley
      @article = bingleys_article
      @root = root
      3.times { create(:criterion, parent_id: @root.id) }
    }

    describe "GET #index" do
      it "returns a success response" do
        @article.criteria.create! valid_attributes
        get criteria_article_path(@article)
        expect(response).to be_successful
      end
    end

    describe "GET #show" do
      it "returns a success response" do
        criterion = @article.criteria.create! valid_attributes
        get criterion_path(criterion)
        expect(response).to be_successful
        assert_select("h3", text: 'Criterion 1')
      end
    end

    describe "GET #new" do
      it "returns a success response" do
        get new_criterion_path(root)
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new criterion" do
          expect {
            post criterion_path(root), params: {criterion: valid_attributes}
          }.to change(Criterion, :count).by(1)
        end

        it "redirects to the created criterion" do
          post criterion_path(root), params: {criterion: valid_attributes}
          expect(response).to redirect_to(@article.criteria.last)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'new' template)" do
          post criterion_path(root), params: {criterion: invalid_attributes}
          expect(response).to be_successful
          expect(response).to render_template(:new)
        end
      end
    end

    describe "GET #edit" do
      it "returns a success response" do
        criterion = @article.criteria.create! valid_attributes
        get edit_criterion_path(criterion)
        expect(response).to be_successful
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          { title: 'A new title' }
        }

        it "updates the requested criterion" do
          criterion = @article.criteria.create! valid_attributes
          put criterion_path(criterion), params: {criterion: new_attributes}
          criterion.reload
          expect(criterion.title).to eq('A new title') 
        end

        it "redirects to the criterion" do
          criterion = @article.criteria.create! valid_attributes
          put criterion_path(criterion), params: {criterion: valid_attributes}
          expect(response).to redirect_to(criterion)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'edit' template)" do
          criterion = @article.criteria.create! valid_attributes
          put criterion_path(criterion), params: {criterion: invalid_attributes}
          expect(response).to render_template('edit')
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested criterion" do
        criterion = @article.criteria.create! valid_attributes
        expect {
          delete criterion_path(criterion.to_param)
        }.to change(Criterion, :count).by(-1)
      end

      it "redirects to the criteria list" do
        criterion = @article.criteria.create! valid_attributes
        delete criterion_path(criterion)
        expect(response).to redirect_to(criteria_article_url(@article))
      end
    end

    describe "showing a criterion" do
      it "shows the left menu panel and model edit menu" do
        criterion = @article.criteria.create! valid_attributes
        get criteria_article_path(@article)
        expect(response).to render_template("criteria/_sidepanel")
        expect(response).to render_template("shared/_model_edit_navbar")
      end
    end

  end

end
