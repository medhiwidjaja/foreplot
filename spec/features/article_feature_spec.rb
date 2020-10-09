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
      @article = create :article, user: bingley
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