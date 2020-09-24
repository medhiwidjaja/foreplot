require 'rails_helper'

RSpec.describe "Viz", type: :request do

  include_context "comparisons context for value tree" 

  context "with signed in user" do
    before(:each) {
      sign_in bingley
    }

    describe "GET #index" do
      it "returns http success" do
        get article_viz_path(article)
        expect(response).to have_http_status(:success)
      end

      it "shows a criteria tree on the sidepanel" do
        get article_viz_path(article)
        expect(response).to render_template("viz/_sidepanel")
      end


    end

    describe "GET #sankey chart json data" do
      it "returns sankey chart data in json format" do
        get article_sankey_path(article, format: :json)
        expect(response.content_type).to eq("application/json")   
        expect(body_as_json).to include(
          nodes: [{id: "Root-0", name: root.title}, {id: "Criterion-#{c1.id}", name: c1.title}, {id: "Criterion-#{c2.id}", name: c2.title}, {id: "Alternative-#{alt1.id}", name: alt1.title}, {id: "Alternative-#{alt2.id}", name: alt2.title}],
          links: [hash_including({"source": "Root-0", "target": "Criterion-#{c1.id}", "value": 0.02})]
        )
      end
    end
  end

end
