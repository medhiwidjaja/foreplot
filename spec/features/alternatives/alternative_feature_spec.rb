require "rails_helper"

RSpec.feature "Alternatives", type: :feature do
  context "Logged in user" do
    let!(:bingley) { create :bingley, :with_articles }
    let!(:article) { bingley.articles.first }
    let(:valid_attributes) {
      { title: 'Alternative 1', description: 'Alternative number one' }
    }
    before(:each) { login_as bingley, scope: :user }

    scenario "User creates a new article" do
      visit new_article_alternative_path(article)
      fill_in 'alternative_title',       with: valid_attributes[:title]
      fill_in 'alternative_description', with: valid_attributes[:description]
      click_button 'Save'
      expect(page).to have_css('h3', text: 'Alternative 1')
      within 'div.side-widget-content' do
        expect(page).to have_content 'Alternative 1'
      end
    end
  
  end

end