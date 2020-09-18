require 'rails_helper'

RSpec.describe AHPComparison, type: :model do
  let!(:article)   { create :article }
  let (:root)      { article.criteria.root }
  let!(:appraisal) { create :appraisal, criterion_id: root.id, appraisal_method:'AHPComparison'}
  
  let!(:alt1)      { create :alternative, article: article, position: 3 }
  let!(:alt2)      { create :alternative, article: article, position: 2 }
  let!(:alt3)      { create :alternative, article: article, position: 1 }

  let!(:crit1)     { create :criterion, parent: root, position: 3, title: "Criterion 1" }
  let!(:crit2)     { create :criterion, parent: root, position: 2, title: "Criterion 2" }
  let!(:crit3)     { create :criterion, parent: root, position: 1, title: "Criterion 3" }

  describe "scope for polymorphic relations" do
    context "with Criterion" do
      before {
        root.children.each do |criterion|
          create :ahp_comparison, appraisal: appraisal, comparable: criterion, position: criterion.position, title: criterion.title
        end
      }
      it "sorts the comparisons according to the position" do
        expect(AHPComparison.count).to eq(3)
        expect(scope_map).to eq [ 
          {comparable_id: crit3.id, comparable_type: 'Criterion', position: 1, name: crit3.title},
          {comparable_id: crit2.id, comparable_type: 'Criterion', position: 2, name: crit2.title},
          {comparable_id: crit1.id, comparable_type: 'Criterion', position: 3, name: crit1.title},
        ]
      end
    end

    context "with Alternative" do
      before {
        article.alternatives.each do |alternative|
          create :ahp_comparison, appraisal: appraisal, comparable: alternative, position: alternative.position, title: alternative.title
        end
      }
      it "sorts the comparisons according to the position" do
        expect(AHPComparison.count).to eq(3)
        expect(scope_map).to eq [ 
          {comparable_id: alt3.id, comparable_type: 'Alternative', position: 1, name: alt3.title},
          {comparable_id: alt2.id, comparable_type: 'Alternative', position: 2, name: alt2.title},
          {comparable_id: alt1.id, comparable_type: 'Alternative', position: 3, name: alt1.title},
        ]
      end
    end
  end
end

def scope_map
  appraisal.ahp_comparisons.order_by_position
    .map {|c| 
      {comparable_id: c.comparable_id, comparable_type: c.comparable_type, position: c.position, name: c.title }
    }
end