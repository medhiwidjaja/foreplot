require 'rails_helper'

RSpec.describe "Sensitivity", type: :request do

  include_context "comparisons context for value tree" 

  context "with signed in user" do
    before(:each) {
      sign_in bingley
    }

    describe "GET #index" do
      it "returns http success" do
        get article_sensitivity_path(article)
        expect(response).to have_http_status(:success)
      end

      it "shows a criteria tree on the sidepanel" do
        get article_sensitivity_path(article)
        expect(response).to render_template("sensitivity/_sidepanel")
      end
    end

    describe "GET #sensitivity chart json data" do
      it "returns sensitivity chart data in json format" do
        get article_sensitivity_data_path(article, format: :json)
        expect(response.content_type).to eq("application/json")   
        expect(body_as_json).to include(
          sensitivity: [[[0.0, 0.4], [1.0, 0.4]], [[0.0, 0.6], [1.0, 0.6]]], 
          chart_data:  [0.6, 0.4],
          labels:      [alt2.title, alt1.title],
          weight:      0.4,
          criterion_id: root.children.order(:position).first.id
        )
      end

      it "returns correct values with provided parameter" do
        get article_sensitivity_data_path(article, criterion_id: c2.id, format: :json)
        expect(response.content_type).to eq("application/json")   
        expect(body_as_json).to include(
          sensitivity: [[[0.0, 0.4], [1.0, 0.4]], [[0.0, 0.6], [1.0, 0.6]]],          
          chart_data:  [0.6, 0.4],
          labels:      [alt2.title, alt1.title],
          weight:      0.6,
          criterion_id: c2.id,
          title:       c2.title
        )
      end
    end

    describe "error handling when there's only 1 subcriterion" do
      before(:each) {
        c1.destroy
      }

      it "returns sensitivity chart data in json format" do
        get article_sensitivity_data_path(article, format: :json)
        expect(response.content_type).to eq("application/json")   
        expect(body_as_json).to include(
          error: "Cannot do sensitivity analysis on single subcriterion",
          status: 400
        )
      end
    end
    
  end

  context "without signed in user" do
    
    it "get #index redirects to login page" do
      get article_sensitivity_path(article)
      expect(response.status).to eql 302
      expect(response).to redirect_to(new_user_session_url)
    end

    it "#chart redirects to login page" do
      get article_sensitivity_data_path(article)
      expect(response.status).to eql 302
      expect(response).to redirect_to(new_user_session_url)
    end
  end

end
