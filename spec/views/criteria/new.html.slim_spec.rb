require 'rails_helper'

RSpec.describe "criteria/new", type: :view do

  let(:article) { FactoryBot.create :article }
  let(:criterion) { FactoryBot.build :criterion }
  before(:each) do
    allow(view).to receive(:user_signed_in?) { true } 
    allow(view).to receive(:current_user) { FactoryBot.build(:user) }
    @article = article
    @criterion = criterion
  end

  it "renders new criterion form" do
    render
    assert_select "form[action=?][method=?]", criterions_path(@criterion), "post" do
      assert_select "input[name=?]", "criterion[title]"
      assert_select "input[name=?]", "criterion[abbrev]"
      assert_select "textarea[name=?]", "criterion[description]"
    end
  end
end
