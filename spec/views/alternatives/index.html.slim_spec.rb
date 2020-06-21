require 'rails_helper'

RSpec.describe "alternatives/index", type: :view do
  context "with 3 alternatives" do
    
    let(:article) { FactoryBot.create :article }
    
    before(:each) do
      @article = article
      assign(:alternatives, [
        FactoryBot.create(:alternative),
        FactoryBot.create(:alternative),
        FactoryBot.create(:alternative)
      ])
    end

    it "displays all 3 alternatives" do
      render
      expect(rendered).to match /Alternative 1/
      expect(rendered).to match /Alternative 2/
      expect(rendered).to match /Alternative 3/
    end
  end
end
