require 'rails_helper'

RSpec.describe "FlowDiagram", type: :request do

  include_context "comparisons context for value tree" 

  context "with signed in user" do
    before(:each) {
      sign_in bingley
    }

    describe "GET #index" do
      it "returns http success" do
        get article_flow_path(article)
        expect(response).to have_http_status(:success)
      end

      it "shows a criteria tree on the sidepanel" do
        get article_flow_path(article)
        expect(response).to render_template("flow/_sidepanel")
      end

      it "shows sankey chart" do
        get article_flow_path(article)
        expect(response).to render_template("flow/_sankey_chart")
      end
    end

    describe "GET #sankey chart json data" do
      it "returns sankey chart data in json format" do
        get article_sankey_path(article, format: :json)
        expect(response.content_type).to eq("application/json")   
        expect(body_as_json).to include(
          nodes: [{name: root.title}, {name: c1.title}, {name: c2.title}, {name: alt1.title}, {name: alt2.title}],
          links: [hash_key_including({"source": root.id, "target": c1.id, "value": 0.02})]
        )
      end
    end
  end

end
