require 'rails_helper'

RSpec.describe "criteria/edit", type: :view do
  let(:article) { FactoryBot.create :article }
  let(:criterion) { FactoryBot.create :criterion }
  before(:each) do
    allow(view).to receive(:user_signed_in?) { true } 
    allow(view).to receive(:current_user) { FactoryBot.build(:user) }
    @article = article
    @criterion = criterion
  end

  it "renders the edit criterion form" do
    render
    assert_select "form[action=?][method=?]", criterion_path(@criterion), "post" do
      assert_select "input[name=?]", "criterion[title]"
      assert_select "input[name=?]", "criterion[abbrev]"
      assert_select "textarea[name=?]", "criterion[description]"
    end
  end
end
