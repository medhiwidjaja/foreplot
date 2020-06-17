require "rails_helper"

RSpec.describe "Home page", :type => :request do

  context "public facing page" do
    it "shows the home page" do
      get "/"
      expect(response).to render_template(:index)
    end
  end
end