require 'rails_helper'

RSpec.describe "articles/index", type: :view do
  context "with 2 articles" do
    before(:each) do
      assign(:articles, [
        FactoryBot.create(:article),
        FactoryBot.create(:article)
      ])
    end

    it "displays both articles" do
      render
      expect(rendered).to match /Article [1..9]/
      expect(rendered).to match /Article [1..9]/
    end
  end
end
