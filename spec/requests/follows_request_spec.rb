require "rails_helper"

RSpec.describe "Follows", :type => :request do

  context "with signed-in users" do
    let (:darcy) { create :darcy }
    let (:bingley) { create :bingley }
    before(:each) {
      sign_in bingley
    }
    describe "following users" do
      it "creates followers record" do
        expect {
          post user_follows_path(user_id: bingley.id, id: darcy.id, format: :js)
        }.to change(Follow, :count).by(1)
      end

      it "sets up associations" do
        post user_follows_path(user_id: bingley.id, id: darcy.id, format: :js)
        expect(bingley.following_users).to include darcy
        expect(darcy.user_followers).to include bingley
      end
    end

    describe "unfollow users" do
      before {
        bingley.follow darcy
      }
      it "deletes followers record" do
        expect {
          delete user_follow_path(user_id: bingley.id, id: darcy.id, format: :js)
        }.to change(Follow, :count).by(-1)
      end

      it "removes associations" do
        delete user_follow_path(user_id: bingley.id, id: darcy.id, format: :js)
        expect(bingley.following_users).to_not include darcy
        expect(darcy.user_followers).to_not include bingley
      end
    end
  end

end