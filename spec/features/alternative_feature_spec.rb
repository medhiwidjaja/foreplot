require "rails_helper"

RSpec.feature "Alternatives", type: :feature do
  context "Logged in user" do
    let!(:bingley) { create :bingley, :with_articles }
    let!(:article) { bingley.articles.first }
    let(:valid_attributes) {
      { title: 'Alternative 1', description: 'Alternative number one' }
    }
    before(:each) { login_as bingley, scope: :user }

    scenario "User creates a new alternative" do
      visit new_article_alternative_path(article)
      fill_in 'alternative_title',       with: valid_attributes[:title]
      fill_in 'alternative_description', with: valid_attributes[:description]
      click_button 'Save'
      expect(page).to have_css('h3', text: 'Alternative 1')
      within 'div.side-widget-content' do
        expect(page).to have_content 'Alternative 1'
      end
    end

    scenario "User edits an alternative" do
      visit article_path(article)
      click_link 'Alternative'
      click_link 'Add new alternative'
      fill_in 'alternative_title',       with: valid_attributes[:title]
      click_button 'Save'
      expect(page).to have_css('h3', text: 'Alternative 1')
      click_link 'Edit'
      fill_in 'alternative_description', with: valid_attributes[:description]
      click_button 'Save'
      within 'blockquote' do
        expect(page).to have_content 'Alternative number one'
      end
    end

    scenario "User doesn't fill in the title field" do
      visit new_article_alternative_path(article)
      fill_in 'alternative_title',       with: ''
      click_button 'Save'
      expect(page).to have_content "can't be blank"
    end

    before { create :alternative, title: 'Good alternative', article: article }

    scenario "User clicks an alternative links from the sidepanel" do
      visit article_alternatives_path(article)
      within 'div.side-widget' do
        click_link 'Good alternative'
      end
      expect(page).to have_content 'This is an alternative'
    end
  
  end

end