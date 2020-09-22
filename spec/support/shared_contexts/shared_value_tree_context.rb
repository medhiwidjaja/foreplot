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

  let(:appraisal1) { create :appraisal, member_id: member.id, criterion: root, appraisal_method:'DirectComparison', comparable_type: 'Criterion' }
  let(:appraisal2) { create :appraisal, member_id: member.id, criterion: c1, appraisal_method:'DirectComparison', comparable_type: 'Alternative' }
  let(:appraisal3) { create :appraisal, member_id: member.id, criterion: c2, appraisal_method:'DirectComparison', comparable_type: 'Alternative' }

  before do
    appraisal1.direct_comparisons << build(:direct_comparison, value: 8, score: 0.4, score_n: 0.4, rank: 2, position: c1.position, title: c1.title, comparable: c1)
    appraisal1.direct_comparisons << build(:direct_comparison, value: 12, score: 0.6, score_n: 0.6, rank: 1, position: c2.position, title: c2.title, comparable: c2)
    
    appraisal2.direct_comparisons << build(:direct_comparison, value: 8, score: 0.4, score_n: 0.4, rank: 2, position: alt1.position, title: alt1.title, comparable: alt1)
    appraisal2.direct_comparisons << build(:direct_comparison, value: 12, score: 0.6, score_n: 0.6, rank: 1, position: alt2.position, title: alt2.title, comparable: alt2)

    appraisal3.direct_comparisons << build(:direct_comparison, value: 8, score: 0.4, score_n: 0.4, rank: 2, position: alt1.position, title: alt1.title, comparable: alt1)
    appraisal3.direct_comparisons << build(:direct_comparison, value: 12, score: 0.6, score_n: 0.6, rank: 1, position: alt2.position, title: alt2.title, comparable: alt2)
  end
end
