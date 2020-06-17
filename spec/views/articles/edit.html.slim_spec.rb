require 'rails_helper'

RSpec.describe "articles/edit", type: :view do
  before(:each) do
    @article = assign(:article, Article.create!(
      :title => "MyString",
      :description => "MyString",
      :likes => 1,
      :slug => "MyString",
      :private => false,
      :active => false
    ))
  end

  it "renders the edit article form" do
    render

    assert_select "form[action=?][method=?]", article_path(@article), "post" do

      assert_select "input[name=?]", "article[title]"

      assert_select "input[name=?]", "article[description]"

      assert_select "input[name=?]", "article[likes]"

      assert_select "input[name=?]", "article[slug]"

      assert_select "input[name=?]", "article[private]"

      assert_select "input[name=?]", "article[active]"
    end
  end
end
