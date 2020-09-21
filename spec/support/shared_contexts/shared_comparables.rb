RSpec.shared_context "shared comparables", :shared_context => :metadata do
  before(:all) do
    article = create :article
    root = article.criteria.root

    3.times { |i| root.children << build(:criterion, article: article, position: i) }
    
    @appraisal = create :appraisal, criterion: root
    @comparables = root.children
  end
end