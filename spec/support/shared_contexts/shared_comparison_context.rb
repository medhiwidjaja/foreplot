RSpec.shared_context "criteria context for comparisons", :shared_context => :metadata do
  before(:all) do
    @bingley = create :bingley
    @article = create :article, user: @bingley
    @member = @article.members.first
    @root = @article.criteria.first
    @criterion = @root

    @c1 = create :criterion, article: @article, parent: @criterion, position: 1
    @c2 = create :criterion, article: @article, parent: @criterion, position: 2
    @c3 = create :criterion, article: @article, parent: @criterion, position: 3

    @alt1 = create :alternative, article: @article, position: 1
    @alt2 = create :alternative, article: @article, position: 2
    @alt3 = create :alternative, article: @article, position: 3
  end
end