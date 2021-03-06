require 'rails_helper'

RSpec.feature "UserProfile", type: :feature do
  context "Logged in user" do
    let!(:bingley) { create :bingley, :with_articles }
    let!(:article) { bingley.articles.first }

    before(:each) { login_as bingley, scope: :user }

    context "User clicks on Articles link" do
      before {
        article.private = true
        @public_article = create :article, title: "My public article", private: false, user: bingley
        @private_article = create :article, title: "My private article", private: true, user: bingley

        visit user_path(bingley)
      }

      scenario "User can see create article button" do
        expect(page).to have_link('New article')
      end

      scenario "private articles" do
        within '#sidepanel' do
          click_link 'Private articles'
        end
        expect(page).to have_content(@private_article.title)
        expect(page).to_not have_content(@public_article.title)
      end

      scenario "public articles" do
        within '#sidepanel' do
          click_link 'Articles'
        end
        expect(page).to have_content(@public_article.title)
        expect(page).to_not have_content(@private_article.title)
      end
    end

    context "With friends" do
      let(:darcy) { create :darcy, :with_articles }
      let(:darcys_article) { darcy.articles.first }
      before {
        bingley.follow darcy
        bingley.follow darcys_article
        darcy.follow bingley
      }

      scenario "Bookmarked article" do
        visit user_path(bingley)
        within '#sidepanel' do
          click_link 'Bookmarks'
        end
        expect(page).to have_content(darcys_article.title)
      end

      scenario "Removing bookmarks", js: true do
        visit user_path(bingley)
        within '#sidepanel' do
          click_link 'Bookmarks'
        end
        within '.btn-group' do
          find('i.icon-trash').click 
        end
        expect(page).to have_content("You have stopped following #{darcys_article.title}")
      end

      scenario "Following friends" do
        visit user_path(bingley)
        within '#sidepanel' do
          click_link 'Following'
        end
        expect(page).to have_content(darcy.name)
      end

      scenario "Followed by friends" do
        visit user_path(bingley)
        within '#sidepanel' do
          click_link 'Followers'
        end
        expect(page).to have_content(darcy.name)
      end

      scenario "Unfollowing friends", js: true do
        visit user_path(bingley)
        within '#sidepanel' do
          click_link 'Following'
        end
        click_link 'Unfollow'
        expect(page).to have_content("You have stopped following #{darcy.name}")
      end

      scenario "Visiting other user's profile" do
        visit user_path(darcy)
        expect(page).to_not have_link('New article')
      end
    end

  end
end