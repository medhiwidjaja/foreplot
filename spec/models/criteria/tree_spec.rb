require 'rails_helper'

RSpec.describe Criteria::Tree do
  let(:article)   { create :article }
  let(:member_id) { article.members.first.id }
  let(:root)      { article.criteria.first }

  before do
    3.times { |i| root.children << create(:criterion, parent_id: root.id, title: "C #{i+1}", article: article) }
    root.children.each do |node|
      2.times { |i| node.children << create(:criterion, parent_id: node.id, title: "#{node.title}-#{i+1}", article: article) } 
    end
  end
  let(:expected_hash) {
    {id:1, label: "Article 1", weights_incomplete: true, children: [
        {id: 2, label: "C 1", weights_incomplete: true, children: [
          {id: 5, label: "C 1-1", weights_incomplete: true},
          {id: 6, label: "C 1-2", weights_incomplete: true}
        ]},
        {id: 3, label: "C 2", weights_incomplete: true, children: [
          {id: 7, label: "C 2-1", weights_incomplete: true},
          {id: 8, label: "C 2-2", weights_incomplete: true}
        ]},
        {id: 4, label: "C 3", weights_incomplete: true, children: [
          {id: 9, label: "C 3-1", weights_incomplete: true},
          {id: 10, label: "C 3-2", weights_incomplete: true}
        ]}
      ]
    }
  }
  let(:expected_json) { expected_hash.to_json }

  let(:tree) { Criteria::Tree.new(article.id, member_id) }

  subject { tree }

  describe "tree creation" do
    it "creates nested tree hash of the criteria" do
      expect(tree.get_tree root.id).to eq(expected_hash)
      expect(tree.as_json_tree root.id).to eq(expected_json)
    end
  end
end
