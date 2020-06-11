require "rails_helper"

RSpec.describe "User sign up", :type => :request do

  let(:valid_attributes) {
    { name: "John Doe", email: "john.doe@gmail.com", password: '12345678',  password_confirmation: '12345678' }
  }
  let(:invalid_attributes) {
    { name: "John Doe", email: " " }
  }

  context "with valid params" do
    it "creates a User and redirects to the User page" do
      get signup_path
      expect(response).to render_template(:signup)

      expect {
        post "/signup", :params => { :user => valid_attributes}
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(assigns(:user))
      follow_redirect!

      expect(response).to render_template(:show)
      expect(response.body).to include("John Doe")
    end
  end

  context "with invalid params" do
    it "doesn't create a new User and render signup template" do
      get signup_path
      expect(response).to render_template(:signup)

      expect {
        post "/signup", :params => { :user => invalid_attributes}
      }.not_to change(User, :count)

      expect(response).to render_template(:signup)
    end
  end

end