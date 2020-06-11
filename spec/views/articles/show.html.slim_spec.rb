require 'rails_helper'

RSpec.describe "articles/show", type: :view do
  before(:each) do
    @article = assign(:article, Article.create!(
      :title => "Title",
      :description => "Description",
      :likes => 2,
      :slug => "Slug",
      :private => false,
      :active => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Slug/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
  end
end
