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
    { id: kind_of(Integer), label: 'Article 1', weights_incomplete: true, 
      children: a_collection_containing_exactly(
        a_hash_including({label: "C 1", weights_incomplete: true, children: 
          a_collection_containing_exactly(
            a_hash_including({label: "C 1-1", weights_incomplete: true}),
            a_hash_including({label: "C 1-2", weights_incomplete: true})
          )
        }),
        a_hash_including({label: "C 2", weights_incomplete: true, children: 
          a_collection_containing_exactly(
            a_hash_including({label: "C 2-1", weights_incomplete: true}),
            a_hash_including({label: "C 2-2", weights_incomplete: true})
          )
        }),
        a_hash_including({label: "C 3", weights_incomplete: true, children: 
          a_collection_containing_exactly(
            a_hash_including({label: "C 3-1", weights_incomplete: true}),
            a_hash_including({label: "C 3-2", weights_incomplete: true})
          )
        })
      )
    }
  }

  let(:tree) { Criteria::Tree.new(article.id, member_id) }

  subject { tree }

  describe "tree creation" do
    it "creates nested tree hash of the criteria" do
      expect(tree.get_tree root.id).to match(expected_hash)
    end
  end

  describe "json tree" do
    it "returns json representation of the tree hash" do
      json = tree.as_json_tree root.id
      parsed_json = JSON.parse json
      expect(parsed_json['label']).to match(/Article/)
      expect(parsed_json['children'].size).to eq(3)
    end
  end
end
