require 'rails_helper'

RSpec.describe "criteria/show", type: :view do
  let(:article) { FactoryBot.create :article }
  let(:criterion) { FactoryBot.create :criterion }
  before(:each) do
    allow(view).to receive(:user_signed_in?) { true } 
    allow(view).to receive(:current_user) { FactoryBot.build(:user) }
    @article = article
    @criterion = criterion
  end

  it "renders attributes" do
    render
    within(".section") do
      expect(rendered).to match(/Criterion 1/)
      expect(rendered).to match(/This is criterion 1/)
    end
    within(".side-widget-content") do
      expect(rendered).to match(/Criterion 1/)
    end
  end
end
