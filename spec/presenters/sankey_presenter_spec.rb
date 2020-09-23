require 'rails_helper'

RSpec.describe SankeyPresenter do
  
  include_context "comparisons context for value tree" 

  let(:value_tree) { 
    ValueTree.new article.id, member.id 
  }

  context "root node" do
    let(:presenter) { SankeyPresenter.new value_tree, root.id }

    it "gives a list of nodes for sankey chart" do
      expect(presenter.sankey_nodes).to eq [
        {id: root.id.to_s, name: root.title}, 
        {id: c2.id.to_s, name: c2.title}, 
        {id: c1.id.to_s, name: c1.title}, 
        {id: alt2.id.to_s, name: alt2.title}, 
        {id: alt1.id.to_s, name: alt1.title}] 
    end

    it "gives a list of links for sankey chart" do
      expect(presenter.sankey_links).to include({"source": root.id.to_s, "target": c1.id.to_s, "value": 0.4})
    end

  end

  context "child node" do
    let(:presenter) { SankeyPresenter.new value_tree, c1.id }

    it "gives a list of nodes for sankey chart" do
      expect(presenter.sankey_nodes).to eq [
        {id: c1.id.to_s, name: c1.title}, 
        {id: alt2.id.to_s, name: alt2.title}, 
        {id: alt1.id.to_s, name: alt1.title}] 
    end

    it "gives a list of links for sankey chart" do
      expect(presenter.sankey_links).to include({"source": c1.id.to_s, "target": alt1.id.to_s, "value": 0.4})
      expect(presenter.sankey_links).to_not include(nil)
    end
  end

end