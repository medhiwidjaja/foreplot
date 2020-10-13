require 'rails_helper'

RSpec.feature "UserProfile", type: :feature do
  context "Logged in user" do
    let!(:bingley) { create :bingley, :with_articles }
    let!(:article) { bingley.articles.first }

    before(:each) { login_as bingley, scope: :user }

    scenario "User clicks on Articles link" do
      visit user_path(bingley)
      within '.side-widget-content' do
        click_link 'Articles'
      end
      expect(page).to have_content(article.title)
    end

    context "With friends" do
      before {
        @darcy = create :darcy, :with_articles 
        @darcys_article = @darcy.articles.first
        bingley.follow @darcy
        bingley.follow @darcys_article
        @darcy.follow bingley

        visit user_path(bingley)
      }

      scenario "Bookmarked article" do
        within '.side-widget-content' do
          click_link 'Bookmarks'
        end
        expect(page).to have_content(@darcys_article.title)
      end

      scenario "Followed friends" do
        within '.side-widget-content' do
          click_link 'Following'
        end
        expect(page).to have_content(@darcy.name)
      end

      scenario "Followed by friends" do
        within '.side-widget-content' do
          click_link 'Followers'
        end
        expect(page).to have_content(@darcy.name)
      end
    end

  end
end