require 'rails_helper'

RSpec.describe "articles/show", type: :view do
  let(:user) { create :bingley }
  before(:each) do
    allow(view).to receive(:current_user) { FactoryBot.create(:user) }
    controller.stub(:controller_name).and_return('articles')
    @article = assign(:article, Article.create!(
      :title => "Title",
      :description => "Description",
      :likes => 2,
      :private => false,
      :active => false,
      :user_id => user.id
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Bingley/)
  end
end
