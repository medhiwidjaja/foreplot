require 'rails_helper'

RSpec.describe "alternatives/edit", type: :view do
  let(:article) { FactoryBot.create :article }
  let(:alternative) { FactoryBot.create :alternative }
  before(:each) do
    allow(view).to receive(:user_signed_in?) { true } 
    allow(view).to receive(:current_user) { FactoryBot.build(:user) }
    @article = article
    @alternative = alternative
  end

  it "renders the edit alternative form" do
    render
    assert_select "form[action=?][method=?]", alternative_path(@alternative), "post" do
      assert_select "input[name=?]", "alternative[title]"
      assert_select "input[name=?]", "alternative[abbrev]"
      assert_select "textarea[name=?]", "alternative[description]"
    end
  end
end
