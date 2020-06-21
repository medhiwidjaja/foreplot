require 'rails_helper'

RSpec.describe "articles/new", type: :view do

  let(:article) { FactoryBot.build :article }
  before(:each) do
    allow(view).to receive(:user_signed_in?) { true } 
    allow(view).to receive(:current_user) { FactoryBot.build(:user) }
    @article = article
  end

  it "renders new article form" do
    render

    assert_select "form[action=?][method=?]", articles_path, "post" do

      assert_select "input[name=?]", "article[title]"
      assert_select "textarea[name=?]", "article[description]"
      assert_select "input[name=?]", "article[private]"
      assert_select "input[name=?]", "article[active]"
    end
  end
end
