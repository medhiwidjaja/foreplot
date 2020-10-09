require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:valid_attributes) {
    { name: "John Doe", email: "john.doe@gmail.com", password: '12345678',  password_confirmation: '12345678', account: 'free', role: 'member' }
  }
  let(:jack) {
    { name: "Jack", email: "jack@gmail.com", password: '12345678',  password_confirmation: '12345678' }
  }
  let(:invalid_attributes) { {full_name: '', email: ''} }

  let(:valid_session) { {} }

  def valid_attributes_except(hash)
    valid_attributes.merge(hash)
  end

  describe "GET #signup" do
    it "assigns a new User to @user" do
      get :signup
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new User" do
        expect {
          post :create, params: {user: valid_attributes}
        }.to change(User, :count).by(1)
      end
    end
  end

end