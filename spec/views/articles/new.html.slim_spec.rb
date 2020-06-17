require 'rails_helper'

RSpec.describe "articles/new", type: :view do
  before(:each) do
    assign(:article, Article.new(
      :title => "MyString",
      :description => "MyString",
      :likes => 1,
      :slug => "MyString",
      :private => false,
      :active => false
    ))
  end

  it "renders new article form" do
    render

    assert_select "form[action=?][method=?]", articles_path, "post" do

      assert_select "input[name=?]", "article[title]"

      assert_select "input[name=?]", "article[description]"

      assert_select "input[name=?]", "article[likes]"

      assert_select "input[name=?]", "article[slug]"

      assert_select "input[name=?]", "article[private]"

      assert_select "input[name=?]", "article[active]"
    end
  end
end
