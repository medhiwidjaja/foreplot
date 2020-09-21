require 'rails_helper'

RSpec.describe AHPComparison, type: :model do

  include_context "criteria context for comparisons"

  let!(:appraisal) { create :appraisal, criterion_id: root.id, appraisal_method:'AHPComparison'}
  
  describe "scope for polymorphic relations" do
    context "with Criterion" do
      before {
        [c3, c2, c1].each do |c|
          create :ahp_comparison, appraisal: appraisal, comparable: c, position: c.position, title: c.title
        end
      }
      it "sorts the comparisons according to the position" do
        expect(AHPComparison.count).to eq(3)
        expect(scope_map).to eq [ 
          {comparable_id: c3.id, comparable_type: 'Criterion', position: 1, name: c3.title},
          {comparable_id: c2.id, comparable_type: 'Criterion', position: 2, name: c2.title},
          {comparable_id: c1.id, comparable_type: 'Criterion', position: 3, name: c1.title}
        ]
      end
    end

    context "with Alternative" do
      before {
        [alt3, alt2, alt1].each do |alternative|
          create :ahp_comparison, appraisal: appraisal, comparable: alternative, position: alternative.position, title: alternative.title
        end
      }
      it "sorts the comparisons according to the position" do
        expect(AHPComparison.count).to eq(3)
        expect(scope_map).to eq [ 
          {comparable_id: alt3.id, comparable_type: 'Alternative', position: 1, name: alt3.title},
          {comparable_id: alt2.id, comparable_type: 'Alternative', position: 2, name: alt2.title},
          {comparable_id: alt1.id, comparable_type: 'Alternative', position: 3, name: alt1.title}
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