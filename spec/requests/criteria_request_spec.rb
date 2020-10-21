require 'rails_helper'

RSpec.describe "Criterion", type: :request do
  let (:bingley) { create :bingley, :with_articles }
  let (:bingleys_article) { bingley.articles.first }
  let (:root) { bingleys_article.criteria.first }
  let(:valid_attributes) {
    { title: 'Criterion 1', article_id: bingleys_article.id, abbrev: 'C#1', parent_id: root.id }
  }
  let(:invalid_attributes) {
    { title: '', article_id: bingleys_article.id }
  }

  context "with signed in user" do
    before(:each) {
      sign_in bingley
      @article = bingleys_article
    }

    describe "GET #index" do
      it "returns a success response" do
        @article.criteria.create! valid_attributes
        get article_criteria_path(@article)
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
            post create_sub_criterion_path(root), params: {criterion: valid_attributes}
          }.to change(Criterion, :count).by(1)
        end

        it "redirects to the created criterion" do
          post create_sub_criterion_path(root), params: {criterion: valid_attributes}
          expect(response).to redirect_to(@article.criteria.last)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'new' template)" do
          post create_sub_criterion_path(root), params: {criterion: invalid_attributes}
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
        expect(response).to redirect_to(article_criteria_url(@article))
      end
    end

    describe "showing a criterion" do
      it "shows the left menu panel and model edit menu" do
        criterion = @article.criteria.create! valid_attributes
        get article_criteria_path(@article)
        expect(response).to render_template("criteria/_sidepanel")
        expect(response).to render_template("shared/_model_edit_navbar")
      end
    end

    describe "criteria tree" do
      let!(:criterion) { @article.criteria.create! valid_attributes }    
      let(:root) { @article.criteria.root }  
      let(:member_id) { @article.members.first.id }
      let(:expected_json) {
        %Q({"id":#{root.id},"label":"#{@article.title}","weights_incomplete":true,"ratings_incomplete":false,"children":[{"id":#{criterion.id},"label":"#{criterion.title}","weights_incomplete":false,"ratings_incomplete":true}]})
      }
      it "returns the JSON object of the criteria tree" do
        get tree_criterion_path(root, p:member_id, format: :json)
        expect(response.body).to eq(expected_json)
      end
    end

  end

  context "updating tree structure with existing appraisals" do
    before(:each) {
      sign_in bingley
      @article = bingleys_article
      create :appraisal, criterion: root, comparable_type: 'Criterion'
    }

    describe "create a new subcriterion" do
      it "deletes appraisals related to parent node" do
        expect {
          post create_sub_criterion_path(root), params: {criterion: valid_attributes}
        }.to change(Appraisal, :count).by(-1)
      end
    end

    describe "deleting a subcriterion" do
      before {
        @subcriterion = create :criterion, parent: root, article: @article
      }
      it "also deletes appraisals related to parent node" do
        expect {
          delete criterion_path(@subcriterion)
        }.to change(root.appraisals, :count).by(-1)
      end
    end
  end

  context "without signed in user" do
    before {
      bingleys_article.update private: true
    }

    it "get #index redirects and shows and error message" do
      get article_criteria_path(bingleys_article)
      expect(response.status).to eql 302
      follow_redirect!
      expect(response.body).to include('You are not authorized')
    end

    it "#show redirects and shows and error message" do
      get criterion_path(root)
      expect(response.status).to eql 302
      follow_redirect!
      expect(response.body).to include('You are not authorized')
    end

    it "#new redirects to login page" do
      post create_sub_criterion_path(root), params: {criterion: valid_attributes}
      expect(response.status).to eql 302
      expect(response).to redirect_to(new_user_session_url)
    end

    it "#edit redirects to login page" do
      get edit_criterion_path(root)
      expect(response.status).to eql 302
      expect(response).to redirect_to(new_user_session_url)
    end

    it "POST redirects to login page" do
      post create_sub_criterion_path(root), params: {criterion: valid_attributes}
      expect(response.status).to eql 302
      expect(response).to redirect_to(new_user_session_url)
    end

    it "PUT redirects to login page" do
      put criterion_path(root), params: {criterion: valid_attributes}
      expect(response.status).to eql 302
      expect(response).to redirect_to(new_user_session_url)
    end

    it "DELETE redirects to login page" do
      delete criterion_path(root)
      expect(response.status).to eql 302
      expect(response).to redirect_to(new_user_session_url)
    end
  end

  context "without signed in user with public article" do
    let(:public_article) { create :article, :public, user: bingley }
    let(:criterion) { public_article.criteria.first }
    
    it "GETs #index for public article" do
      get article_criteria_path(public_article)
      expect(response).to be_successful
    end

    it "GETs #show for public article" do
      get criterion_path(criterion)
      expect(response).to be_successful
    end

    it "GETs #tree for public article" do
      get tree_criterion_path(criterion, format: :json)
      expect(response).to be_successful
    end

    it "redirects on GET #edit for public article" do
      get edit_criterion_path(criterion)
      expect(response.status).to eql 302
    end

    it "redirects on GET #new for public article" do
      get new_criterion_path(criterion)
      expect(response.status).to eql 302
    end

    it "redirects on DELETE for public article" do
      delete criterion_path(criterion)
      expect(response.status).to eql 302
    end
  end
end
