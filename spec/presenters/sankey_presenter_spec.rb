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
        {id: "Root-0", name: root.title}, 
        {id: "Criterion-#{c2.id}", name: c2.title}, 
        {id: "Criterion-#{c1.id}", name: c1.title}, 
        {id: "Alternative-#{alt2.id}", name: alt2.title}, 
        {id: "Alternative-#{alt1.id}", name: alt1.title}] 
    end

    it "gives a list of links for sankey chart" do
      expect(presenter.sankey_links).to include({"source": "Root-0", "target": "Criterion-#{c1.id}", "value": 0.4})
    end

  end

  context "child node" do
    let(:presenter) { SankeyPresenter.new value_tree, c1.id }

    it "gives a list of nodes for sankey chart" do
      expect(presenter.sankey_nodes).to eq [
        {id: "Root-0", name: c1.title}, 
        {id: "Alternative-#{alt2.id}", name: alt2.title}, 
        {id: "Alternative-#{alt1.id}", name: alt1.title}] 
    end

    it "gives a list of links for sankey chart" do
      expect(presenter.sankey_links).to include({"source": "Root-0", "target": "Alternative-#{alt1.id}", "value": 0.4})
      expect(presenter.sankey_links).to_not include(nil)
    end
  end

end