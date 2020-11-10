require "rails_helper"

RSpec.describe "Member", :type => :request do

  context "with signed-in users" do
    let (:bingley) { create :bingley }
    let (:article) { create :article, user: bingley}
    let (:user1)   { build :user, name: 'Fitzwilliam' }
    let (:user2)   { build :user, name: 'Collins' }
    let (:user3)   { build :user, name: "Darcy" }
    before {
      sign_in bingley
      article.members << [user1, user2, user3].map { |user| Member.new user: user, role: 'viewer' }
    }

    describe "new" do
      it "returns a success response" do
        get new_article_member_path(article)
        expect(response).to be_successful
      end
    end

    describe "new_request" do
      it "returns a success response" do
        get new_request_article_members_path(article)
        expect(response).to be_successful
      end
    end

    describe "index" do
      it "lists all article's members" do
        get article_members_path(article)
        expect(response).to be_successful
        ['Fitzwilliam', 'Collins', 'Darcy'].each {|name| expect(response.body).to include name }
      end
    end

    describe "show" do
      it "displays a member's profile" do
        get member_path(article.members.last)
        expect(response).to be_successful
        expect(response.body).to include 'Darcy'
      end
    end
  end

end