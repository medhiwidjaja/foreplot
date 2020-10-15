require 'rails_helper'

RSpec.describe "articles/edit", type: :view do
  let(:bingley) { create :bingley, :with_articles }
  let(:article) { bingley.articles.first }
  before(:each) do
    allow(view).to receive(:user_signed_in?) { true } 
    allow(view).to receive(:current_user) { FactoryBot.create(:user) }
    @article = article
  end

  it "renders the edit article form" do
    render

    assert_select "form[action=?][method=?]", article_path(@article), "post" do

      assert_select "input[name=?]", "article[title]"
      assert_select "textarea[name=?]", "article[description]"
      assert_select "input[name=?]", "article[private]"
      assert_select "input[name=?]", "article[active]"

    end
  end
end
