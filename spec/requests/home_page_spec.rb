require "rails_helper"

RSpec.describe "Home page", :type => :request do

  context "public facing page" do
    it "shows the home page" do
      get root_path
      expect(response).to render_template(:index)
      expect(response.body).to include('/users/sign_in')
      expect(response.body).to include('/users/sign_up')
    end
  end

  context "authenticated home page" do
    it "signs user in and out" do
      user = create :user
      
      sign_in user
      get root_path
      expect(response).to render_template(:index)
      expect(controller.current_user).to eq(user)
      expect(response.body).not_to include('/users/sign_in')

      sign_out user
      get root_path
      expect(controller.current_user).to be_nil
    end
  end
end
