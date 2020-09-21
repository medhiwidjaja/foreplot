RSpec.shared_context "comparisons context for value tree", :shared_context => :metadata do
  let(:bingley)   { create :bingley, :with_articles }
  let(:article)   { bingley.articles.first }
  let(:member)    { article.members.first }
  let(:root)      { article.criteria.first }
  let(:criterion) { root }

  let(:c1)   { create :criterion, article: article, parent: criterion, position: 1 }
  let(:c2)   { create :criterion, article: article, parent: criterion, position: 2 }

  let(:alt1) { create :alternative, article: article, position: 1 }
  let(:alt2) { create :alternative, article: article, position: 2 }

  before do
    app1 = create :appraisal, member_id: member.id, criterion: root, appraisal_method:'DirectComparison', comparable_type: 'Criterion'
    app1.direct_comparisons << build(:direct_comparison, value: 8, score: 0.4, comparable: c1)
    app1.direct_comparisons << build(:direct_comparison, value: 12, score: 0.6, comparable: c2)
    
    app2 = create :appraisal, member_id: member.id, criterion: c1, appraisal_method:'DirectComparison', comparable_type: 'Alternative'
    app2.direct_comparisons << build(:direct_comparison, value: 8, score: 0.4, comparable: alt1)
    app2.direct_comparisons << build(:direct_comparison, value: 12, score: 0.6, comparable: alt2)

    app3 = create :appraisal, member_id: member.id, criterion: c2, appraisal_method:'DirectComparison', comparable_type: 'Alternative'
    app3.direct_comparisons << build(:direct_comparison, value: 8, score: 0.4, comparable: alt1)
    app3.direct_comparisons << build(:direct_comparison, value: 12, score: 0.6, comparable: alt2)
  end
end
