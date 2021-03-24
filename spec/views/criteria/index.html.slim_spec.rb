require 'rails_helper'

RSpec.describe "criteria/index", type: :view do
    
  let(:article) { FactoryBot.create :article, title: "Great article" }
  let(:root) { article.criteria.first }
  before(:each) do
    controller.stub(:controller_name).and_return('criteria')
    @article = article
    @presenter = double(article: article, root: root, member_id:1, allow_navigate: true, parent_id: root.id, 
                        criterion: root, table: nil, comparison_type: 'DirectComparison', appraisal: nil,
                        confirm_destroy_related_appraisals: true)
  end

  it "displays the root criterion" do
    render
    expect(rendered).to match /Great article/
  end

end
