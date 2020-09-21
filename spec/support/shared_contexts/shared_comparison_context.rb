RSpec.shared_context "criteria context for comparisons", :shared_context => :metadata do
  let(:bingley)   { create :bingley, :with_articles }
  let(:article)   { bingley.articles.first }
  let(:member)    { article.members.first }
  let(:root)      { article.criteria.first }
  let(:criterion) { root }
  
  let(:c1)   { create :criterion, article: article, parent: criterion, position: 1 }
  let(:c2)   { create :criterion, article: article, parent: criterion, position: 2 }
  let(:c3)   { create :criterion, article: article, parent: criterion, position: 3 }

  let(:alt1) { create :alternative, article: article, position: 1 }
  let(:alt2) { create :alternative, article: article, position: 2 }
  let(:alt3) { create :alternative, article: article, position: 3 }

end