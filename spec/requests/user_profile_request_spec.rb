require "rails_helper"

RSpec.describe "User Profile", :type => :request do
  let(:bingley) { create :bingley }
  let(:darcy) { create :darcy }
  let(:valid_attributes) {
    { name: "Mr. Bingley", email: "bingley@netherfield.net", bio: '£5,000 a year' }
  }
  let(:invalid_attributes) {
    { name: "John Doe", email: " " }
  }

  context "without logged in user" do
    it "allows to read a user's profile" do
      get user_path(bingley)
      expect(response).to redirect_to( new_user_session_path )
    end

    it "won't allow the user to edit" do
      get edit_user_path(bingley)
      expect(response).to redirect_to( new_user_session_path )
    end
  end

  context "with logged in user" do
    before {
      sign_in bingley
    }
    it "allows to read a user's profile" do
      get user_path(darcy)
      expect(response.body).to include(bingley.name)
    end

    it "allows the user to edit" do
      get edit_user_path(bingley)
      expect(response).to be_successful
    end

    it "allows the user to edit his bio" do
      patch user_path(bingley), params: {user: valid_attributes}
      expect(bingley.reload.bio).to eq '£5,000 a year'
    end

    it "won't allow the user to edit" do
      get edit_user_path(darcy)
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include('You are not authorized')
    end
  end

end