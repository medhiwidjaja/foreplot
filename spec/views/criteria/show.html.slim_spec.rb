require 'rails_helper'

RSpec.describe "criteria/show", type: :view do
  let(:article) { FactoryBot.create :article }
  let(:criterion) { article.criteria.first }
  before(:each) do
    allow(view).to receive(:user_signed_in?) { true } 
    allow(view).to receive(:current_user) { FactoryBot.build(:user) }
    @article = article
    @criterion = criterion
    @presenter = double(article: article, root: criterion, member_id:1, allow_navigate: true, parent_id: criterion.id, parent: criterion,
                        criterion: criterion, table: nil, comparison_type: 'DirectComparison', appraisal: nil,
                        confirm_destroy_related_appraisals: true)
  end

  it "renders attributes" do
    render
    within(".section") do
      expect(rendered).to match(/Criterion 1/)
      expect(rendered).to match(/This is criterion 1/)
    end
    within(".side-widget-content") do
      expect(rendered).to match(/Criterion 1/)
    end
  end
end
