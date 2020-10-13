require "rails_helper"

RSpec.describe "User sign up", :type => :request do

  let(:valid_attributes) {
    { name: "John Doe", email: "john.doe@gmail.com", password: '12345678', password_confirmation: '12345678', role: 'member', account: 'free' }
  }
  let(:invalid_attributes) {
    { name: "John Doe", email: " " }
  }

  context "with valid params" do
    it "creates a User and redirects to the home page" do
      get new_user_registration_path

      expect {
        post user_registration_path, :params => { :user => valid_attributes}
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(root_path)
      follow_redirect!

      expect(response.body).to include("Welcome! You have signed up successfully.")
    end
  end

  context "with invalid params" do
    it "doesn't create a new User and render signup template" do
      get new_user_registration_path

      expect {
        post user_registration_path, :params => { :user => invalid_attributes}
      }.not_to change(User, :count)

    end
  end

end