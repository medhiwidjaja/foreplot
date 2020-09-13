require 'rails_helper'

RSpec.describe ValueTree, type: :model do

  let(:bingley) { create :bingley, :with_articles }
  let(:bingleys_article) { bingley.articles.first }
  let(:member)  { bingleys_article.members.first }
  let(:root) { bingleys_article.criteria.first }

  let!(:alt1) { create :alternative, article: bingleys_article }
  let!(:alt2) { create :alternative, article: bingleys_article }

  let!(:c1) { create :criterion, article:bingleys_article, parent:root }
  let!(:c2) { create :criterion, article:bingleys_article, parent:root }

  let(:value_tree) { ValueTree.new bingleys_article.id, member.id, root.id }

  subject { value_tree }

  before do
    app1 = create(:appraisal, member_id: member.id, criterion: root, appraisal_method:'DirectComparison', comparable_type: 'Criterion')
    app1.direct_comparisons << build(:direct_comparison, value: 4, score: 0.4, comparable: c1)
    app1.direct_comparisons << build(:direct_comparison, value: 6, score: 0.6, comparable: c2)
    
    app2 = create(:appraisal, member_id: member.id, criterion: c1, appraisal_method:'DirectComparison', comparable_type: 'Alternative')
    app2.direct_comparisons << build(:direct_comparison, value: 4, score: 0.4, comparable: alt1)
    app2.direct_comparisons << build(:direct_comparison, value: 6, score: 0.6, comparable: alt2)

    app3 = create(:appraisal, member_id: member.id, criterion: c2, appraisal_method:'DirectComparison', comparable_type: 'Alternative')
    app3.direct_comparisons << build(:direct_comparison, value: 4, score: 0.4, comparable: alt1)
    app3.direct_comparisons << build(:direct_comparison, value: 6, score: 0.6, comparable: alt2)
  end

  describe "initialize" do

    let(:expected_keys) { ["#{root.id}-Criterion-#{c1.id}", "#{root.id}-Criterion-#{c2.id}", "#{c1.id}-Alternative-#{alt1.id}", "#{c1.id}-Alternative-#{alt2.id}", "#{c2.id}-Alternative-#{alt1.id}", "#{c2.id}-Alternative-#{alt2.id}"] }

    describe ".initialize" do
      it "initializes value tree from article and member params" do
        expect(subject.article_id).to eq(bingleys_article.id)
        expect(subject.member_id).to eq(member.id)
      end

      it "initializes tree data" do
        expect(subject.tree_data.size).to eq 5
        expect(subject.tree_data["#{root.id}-Criterion"]["title"]).to eq "Bingley's article"
        expect(subject.tree_data["#{root.id}-Criterion"]["children"]).to eq "{#{c2.id},#{c1.id}}"
      end

      it "initializes score data" do
        expect(subject.score_data.size).to eq 6
        expect(subject.score_data.map {|k, _v| k }).to eq expected_keys
      end
    end
  end

  describe ".build_tree" do
      
    before {
      @tree = value_tree.build_tree(root.id, 'Criterion'){|n| {id:n.id, name:n.title, score:n.score} }
    }

    it "builds the value tree" do
      expect(@tree.class).to eq Tree::TreeNode
      expect(@tree.node_height).to eq 2
    end

    
  end
end