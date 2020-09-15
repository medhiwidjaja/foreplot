RSpec.shared_context "comparisons context for value tree", :shared_context => :metadata do
  before(:all) do
    @bingley = create :bingley, :with_articles
    @bingleys_article = @bingley.articles.first
    @member = @bingleys_article.members.first
    @root = @bingleys_article.criteria.first
  
    @alt1 = create :alternative, article: @bingleys_article
    @alt2 = create :alternative, article: @bingleys_article
  
    @c1 = create :criterion, article:@bingleys_article, parent:@root
    @c2 = create :criterion, article:@bingleys_article, parent:@root

    app1 = create :appraisal, member_id: @member.id, criterion: @root, appraisal_method:'DirectComparison', comparable_type: 'Criterion'
    app1.direct_comparisons << build(:direct_comparison, value: 8, score: 0.4, comparable: @c1)
    app1.direct_comparisons << build(:direct_comparison, value: 12, score: 0.6, comparable: @c2)
    
    app2 = create :appraisal, member_id: @member.id, criterion: @c1, appraisal_method:'DirectComparison', comparable_type: 'Alternative'
    app2.direct_comparisons << build(:direct_comparison, value: 8, score: 0.4, comparable: @alt1)
    app2.direct_comparisons << build(:direct_comparison, value: 12, score: 0.6, comparable: @alt2)

    app3 = create :appraisal, member_id: @member.id, criterion: @c2, appraisal_method:'DirectComparison', comparable_type: 'Alternative'
    app3.direct_comparisons << build(:direct_comparison, value: 8, score: 0.4, comparable: @alt1)
    app3.direct_comparisons << build(:direct_comparison, value: 12, score: 0.6, comparable: @alt2)
  end
end
