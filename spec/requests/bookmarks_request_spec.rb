require "rails_helper"

RSpec.describe "Bookmarks", :type => :request do

  context "bookmarking with signed-in users" do
    let (:article) { create :article }
    let (:bingley) { create :bingley }
    before(:each) {
      sign_in bingley
    }
    describe "bookmarking articles" do
      it "creates followers record" do
        expect {
          post user_bookmarks_path(user_id: bingley.id, id: article.id, format: :js)
        }.to change(Follow, :count).by(1)
      end

      it "sets up associations" do
        post user_bookmarks_path(user_id: bingley.id, id: article.id, format: :js)
        expect(bingley.following_articles).to include article
        expect(article.followers).to include bingley
      end
    end

    describe "removing bookmarks" do
      before {
        bingley.follow article
      }
      it "deletes followers record" do
        expect {
          delete user_bookmark_path(user_id: bingley.id, id: article.id, format: :js)
        }.to change(Follow, :count).by(-1)
      end

      it "removes associations" do
        delete user_bookmark_path(user_id: bingley.id, id: article.id, format: :js)
        expect(bingley.following_articles).to_not include article
        expect(article.followers).to_not include bingley
      end
    end
  end

end