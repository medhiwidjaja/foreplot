require 'rails_helper'

RSpec.describe ValueTree, type: :model do

  include_context "comparisons context for value tree" 

  let(:value_tree) { 
    ValueTree.new(article.id, member.id) 
  }

  subject { value_tree }

  describe ".initialize" do
    it "initializes value tree from article and member params" do
      expect(subject.article_id).to eq(article.id)
      expect(subject.member_id).to eq(member.id)
    end

    it "initializes tree data" do
      expect(subject.tree_data.size).to eq 5
      expect(subject.tree_data["#{root.id}-Criterion"][:title]).to eq "Bingley's article"
      expect(subject.tree_data["#{root.id}-Criterion"][:children]).to include "#{c1.id}", "#{c2.id}"
    end

    it "initializes score data" do
      expect(subject.score_data.size).to eq 6
      expect(subject.score_data.map {|k, _v| k }).to include "#{root.id}-Criterion-#{c1.id}", "#{root.id}-Criterion-#{c2.id}", "#{c1.id}-Alternative-#{alt1.id}", "#{c1.id}-Alternative-#{alt2.id}", "#{c2.id}-Alternative-#{alt1.id}", "#{c2.id}-Alternative-#{alt2.id}"
    end
  end

  describe "tree structure" do
    before {
      value_tree.build_tree(root.id) {|n| {:id => n.comparable_id, :name => n.title, :score => n.score, :criterion => n.cid} } 
    }
      
    let(:tree) { value_tree.tree }

    it "builds the value tree" do
      expect(tree.class).to eq Tree::TreeNode
      expect(tree.node_height).to eq 2
    end

    it "creates right contents in each node" do
      expect(tree.children.map {|c| c.content}).to include(hash_including({:name => c1.title, :score => 0.4})) 
      expect(tree.children.map {|c| c.content}).to include(hash_including({:name => c2.title, :score => 0.6}))
      expect(tree.children.first.children.map {|c| c.content}).to include(hash_including({:name => alt1.title, :score => 0.4}))
      expect(tree.children.first.children.map {|c| c.content}).to include(hash_including({:name => alt2.title, :score => 0.6}))
    end

    it "normalizes the scores of tree's nodes" do
      value_tree.normalize! :score
      expect(tree.content[:sum]).to eq 1.0
      expect(tree.children.map {|c| c.content}).to include(hash_including({:score_n => 0.4}), hash_including({:score_n => 0.6}))
    end

    it "globalizes the scores of tree's nodes" do
      value_tree.normalize! :score
      value_tree.globalize! :score
      tree.each_leaf {|node|
        @node1 = node if node.content[:id] == alt1.id && node.content[:criterion] == c1.id
        @node2 = node if node.content[:id] == alt2.id && node.content[:criterion] == c1.id
        @node3 = node if node.content[:id] == alt1.id && node.content[:criterion] == c2.id
        @node4 = node if node.content[:id] == alt2.id && node.content[:criterion] == c2.id
      }
      expect(@node1.content).to match(hash_including({:name => alt1.title, :score_g => 0.4*0.4, :criterion => c1.id}))
      expect(@node2.content).to match(hash_including({:name => alt2.title, :score_g => 0.4*0.6, :criterion => c1.id}))
      expect(@node3.content).to match(hash_including({:name => alt1.title, :score_g => 0.6*0.4, :criterion => c2.id}))
      expect(@node4.content).to match(hash_including({:name => alt2.title, :score_g => 0.6*0.6, :criterion => c2.id}))
    end
  end

  describe "incomplete evaluations" do
    before {
      appraisal3.destroy
    }
    it "makes the value invalid" do
      expect(value_tree.invalid).to eq true
    end
  end
end