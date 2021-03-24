require 'rails_helper'

RSpec.describe "alternatives/index", type: :view do
  context "with 3 alternatives" do
    
    let(:article) { FactoryBot.create :article }
    
    before(:each) do
      @article = article
      assign(:alternatives, [
        FactoryBot.create(:alternative, title: 'Alternative no. 1'),
        FactoryBot.create(:alternative, title: 'Alternative no. 2'),
        FactoryBot.create(:alternative, title: 'Alternative no. 3')
      ])
      controller.stub(:controller_name).and_return('alternatives')
    end

    it "displays all 3 alternatives" do
      render
      expect(rendered).to match /Alternative no. 1/
      expect(rendered).to match /Alternative no. 2/
      expect(rendered).to match /Alternative no. 3/
    end
  end
end
