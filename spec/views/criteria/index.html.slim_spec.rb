require 'rails_helper'

RSpec.describe "criteria/index", type: :view do
  context "with 3 criteria" do
    
    let(:article) { FactoryBot.create :article }
    
    before(:each) do
      @article = article
      assign(:criteria, [
        FactoryBot.create(:criterion),
        FactoryBot.create(:criterion),
        FactoryBot.create(:criterion)
      ])
    end

    it "displays all 3 criteria" do
      render
      expect(rendered).to match /Criterion 1/
      expect(rendered).to match /Criterion 2/
      expect(rendered).to match /Criterion 3/
    end

  end
end
