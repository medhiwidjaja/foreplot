require 'rails_helper'

RSpec.describe "alternatives/show", type: :view do
  let(:article) { FactoryBot.create :article }
  let(:alternative) { FactoryBot.create :alternative }
  before(:each) do
    allow(view).to receive(:user_signed_in?) { true } 
    allow(view).to receive(:current_user) { FactoryBot.build(:user) }
    @article = article
    @alternative = alternative
  end

  it "renders attributes" do
    render
    within(".section") do
      expect(rendered).to match(/Alternative 1/)
      expect(rendered).to match(/This is an alternative/)
    end
    within(".side-widget-content") do
      expect(rendered).to match(/Alternative 1/)
    end
  end
end
