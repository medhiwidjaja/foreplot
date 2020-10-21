require "rails_helper"

RSpec.feature "Article", type: :feature do
  context "Logged in user" do
    let!(:bingley) { create :bingley }
    let(:valid_attributes) {
      { title: 'Article 1', description: 'Article number one', user_id: bingley.id }
    }
    before(:each) { login_as bingley, scope: :user }

    scenario "User creates a new article" do
      visit new_article_path
      fill_in 'article_title',       with: valid_attributes[:title]
      fill_in 'article_description', with: valid_attributes[:description]
      click_button 'Save'
      expect(page).to have_css('h3', text: 'Article 1')
    end

    before {
      @article = create :article, :public, user: bingley
    }
    scenario "User edits an article" do 
      visit article_path(@article)
      click_link 'Edit'
      fill_in 'article_title',       with: valid_attributes[:title]
      fill_in 'article_description', with: valid_attributes[:description]
      click_button 'Save'
      expect(page).to have_css('h3', text: 'Article 1')
      expect(page).to have_content 'Article number one'
    end

    scenario "User doesn't fill in the title field" do
      visit new_article_path
      fill_in 'article_title',       with: ''
      click_button 'Save'
      expect(page).to have_content "can't be blank"
    end

    scenario "User will see create edit button" do 
      visit articles_path
      expect(page).to have_link('Create new article')
    end

    scenario "User views a single article" do
      visit article_path(@article)
      expect(page).to have_link('Edit')
    end

    describe "Following / unfollowing the author", js: true do
      before {
        @darcy = create :darcy
        @darcys_article = create :article, user: @darcy
      }
      scenario "User follows the author and then unfollows again" do
        visit article_path(@darcys_article)
        expect(page).to have_link('Follow')
        click_link 'Follow' 
        expect(page).to have_content("You are now following #{@darcy.name}")
        expect(page).to_not have_link('Follow')
        expect(page).to have_link('Unfollow')
        click_link 'Unfollow'
        expect(page).to have_content("You have stopped following #{@darcy.name}")
        expect(page).to have_link('Follow')
        expect(page).to_not have_link('Unfollow')
      end
    end

    describe "Bookmarking an article", js: true do
      before {
        @darcy = create :darcy
        @darcys_article = create :article, user: @darcy
      }
      scenario "User bookmarks an article" do
        visit article_path(@darcys_article)
        within '.btn-group' do
          click_link "Add" 
        end
        expect(page).to have_content("You are now following #{@darcys_article.title}")
      end
    end

    describe "Unbookmarking an article", js: true do 
      before {
        @darcy = create :darcy
        @darcys_article = create :article, user: @darcy
        bingley.follow @darcys_article
      }
      scenario "User remove a bookmark" do
        visit article_path(@darcys_article)
        within '.btn-group' do
          find('i.icon-trash').click 
        end
        expect(page).to have_content("You have stopped following #{@darcys_article.title}")
      end
    end
  end

  context "with other user's article" do
    let!(:bingley) { create :bingley }
    let!(:article) { create :article, :public, title: "Bingley's public article", user: bingley }
    let!(:darcy) { create :darcy }

    before(:each) { 
      login_as darcy, scope: :user 
    }

    scenario "Darcy views Bingley's public article" do
      visit article_path(article)
      expect(page).to have_content("Bingley's public article")
      expect(page).to_not have_link('Edit')
    end
  end

  context "Guest user" do
    let!(:guest) { create :guest_user }
    before(:each) { login_as guest, scope: :user }

    scenario "User won't see create edit button" do 
      visit articles_path
      expect(page).not_to have_link('Create new article')
    end
  end
end