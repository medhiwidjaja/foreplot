require 'rails_helper'

RSpec.describe "criteria/new", type: :view do

  let(:article) { FactoryBot.create :article }
  let(:criterion) { article.criteria.first }
  before(:each) do
    allow(view).to receive(:user_signed_in?) { true } 
    allow(view).to receive(:current_user) { FactoryBot.build(:user) }
    controller.stub(:controller_name).and_return('criteria')
    @article = article
    @criterion = criterion
    @presenter = double(article: article, root: criterion, member_id:1, allow_navigate: true, parent_id: criterion.id, parent: criterion,
      criterion: criterion, table: nil, comparison_type: 'DirectComparison', appraisal: nil)
  end

  it "renders new criterion form" do
    render
    assert_select "form[action=?][method=?]", criterion_path(@criterion), "post" do
      assert_select "input[name=?]", "criterion[title]"
      assert_select "input[name=?]", "criterion[abbrev]"
      assert_select "textarea[name=?]", "criterion[description]"
    end
  end
end
