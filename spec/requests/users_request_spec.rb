require "rails_helper"

RSpec.describe "Users", :type => :request do

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

      expect(response.body).to include("A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.")
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

  describe "request for autocompletion" do
    let(:bingley) { create :bingley }
    before {
      sign_in bingley
      @user1 = create :user, name: 'Fitzgerald', email:'fg@email.net'
      @user2 = create :user, name: 'Collins', email:'collins@email.net'
      @user3 = create :user, name: "Darcy", email:'fitzwilliam@pemberley.com'
    }

    it "responds with json based on partial match" do
      get users_path(match:'fitz', format: :json)
      expect(response.content_type).to eq("application/json")
      expect(body_as_json).to include(
        {id: @user1.id, name: @user1.name, email: @user1.email},
        {id: @user3.id, name: @user3.name, email: @user3.email}
      )
      expect(body_as_json).to_not include(
        {id: @user2.id, name: @user2.name, email: @user2.email}
      )
    end
  end

end